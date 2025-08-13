import {createClient} from "./server";

export const signIn = async (email: string, password: string) => {
  try {
    const supabase = await createClient();
    const {data, error} = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) throw error;

    return data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      console.error("Sign in failed:", error.message);
      throw new Error(error.message);
    } else {
      console.error("Unknown error during sign in");
      throw new Error("An unknown error occurred");
    }
  }
};

export const signUp = async (email: string, password: string, name: string) => {
  try {
    const supabase = await createClient();
    const {data, error} = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          name,
        },
      },
    });

    if (error) throw error;

    if (data.user) {
      const {error: profileError} = await supabase
        .from('profiles')
        .insert([
          {
            id: data.user.id,
            email,
            name,
          },
        ]);

      if (profileError) throw profileError;
    }

    return data;
  } catch (error: unknown) {
    if (error instanceof Error) {
      console.error("Sign up failed:", error.message);
      throw new Error(error.message);
    } else {
      console.error("Unknown error during sign up");
      throw new Error("An unknown error occurred");
    }
  }
};

export const signOut = async () => {
  try {
    const supabase = await createClient();
    await supabase.auth.signOut();
  } catch (error: unknown) {
    if (error instanceof Error) {
      console.error("Sign out failed:", error.message);
      throw new Error(error.message);
    } else {
      console.error("Unknown error during sign out");
      throw new Error("An unknown error occurred");
    }
  }
};

export const getSession = async () => {
  try {
    const supabase = await createClient();
    const {data} = await supabase.auth.getSession();
    return data.session;
  } catch (error: unknown) {
    if (error instanceof Error) {
      console.error("Get session failed:", error.message);
    } else {
      console.error("Unknown error during session retrieval");
    }
    return null;
  }
};
