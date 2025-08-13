import {NextResponse} from 'next/server';

import {signUp} from '@/utils/supabase/helper';

export async function POST(request: Request) {
  const {name, email, password} = await request.json();

  if (!email || !password || !name) {
    return NextResponse.json(
      {message: 'Todos los campos son requeridos'},
      {status: 400}
    );
  }

  if (password.length < 6) {
    return NextResponse.json(
      {message: 'La contraseña debe tener al menos 8 caracteres'},
      {status: 400}
    );
  }

  try {
    const data = await signUp(email, password, name);

    return NextResponse.json(
      {
        message: 'Registro exitoso! Por favor verifica tu correo electrónico.',
        user: data.user
      },
      {status: 201}
    );
  } catch (error) {
    if (error instanceof Error) {
      return NextResponse.json(
        {message: error.message},
        {status: 500}
      );
    }
    return NextResponse.json(
      {message: 'Error desconocido al registrar usuario'},
      {status: 500}
    );
  }
}
