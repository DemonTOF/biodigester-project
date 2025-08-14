'use server';

import {createClient} from "./server";

import {redirect} from 'next/navigation';

export const signIn = async (email: string, password: string) => {
  const supabase = await createClient();
  const {error} = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    return {error: error.message};
  }

  return redirect('/');
};

export const signUp = async (credentials: {
  name: string;
  email: string;
  username: string;
  password: string;
  confirmPassword: string;
}) => {
  const {name, email, username, password, confirmPassword} = credentials;

  // Validaciones
  if (!name || !email || !username || !password || !confirmPassword) {
    return {error: 'Todos los campos son requeridos'};
  }

  if (password.length < 8) {
    return {error: 'La contraseña debe tener al menos 8 caracteres'};
  }

  if (password !== confirmPassword) {
    return {error: 'Las contraseñas no coinciden'};
  }

  const supabase = await createClient();

  try {
    // 1. Registrar usuario
    const {data, error} = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          name,
          username,
          display_name: username
        }
      },
    });

    if (error) {
      return {error: error.message};
    }

    // 2. Crear perfil en la tabla profiles si existe
    if (data.user) {
      try {
        await supabase
          .from('profiles')
          .insert([{
            id: data.user.id,
            email,
            name,
            username,
            display_name: username
          }]);
      } catch (profileError) {
        console.error('Error creating profile:', profileError);
      }
    }

    // 3. Iniciar sesión automáticamente
    const {error: signInError} = await supabase.auth.signInWithPassword({
      email,
      password
    });

    if (signInError) {
      return {error: signInError.message};
    }

    return {success: true};

  } catch (error: unknown) {
    return {
      error: error instanceof Error ? error.message : 'Ocurrió un error desconocido.'
    };
  }
};

export const signOut = async () => {
  const supabase = await createClient();
  await supabase.auth.signOut();
  return redirect('/login');
};

export const getSession = async () => {
  try {
    const supabase = await createClient();
    const {data} = await supabase.auth.getSession();
    return data.session;
  } catch (error: unknown) {
    console.error("Error obteniendo sesión:", error instanceof Error ? error.message : error);
    return null;
  }
};

export const redirectIfAuthenticated = async (path: string = '/') => {
  const session = await getSession();
  if (session) {
    redirect(path);
  }
};
