import {redirectIfAuthenticated, signIn} from '@/utils/supabase/auth';

import LoginForm from './login-form';

export default async function LoginPage() {
  await redirectIfAuthenticated();

  return (
    <div
      className="relative flex min-h-screen flex-col items-center justify-center bg-gradient-to-br from-slate-50 to-slate-100 p-4">
      <LoginForm signInAction={signIn}/>
    </div>
  );
}
