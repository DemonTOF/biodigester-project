import {redirectIfAuthenticated, signUp} from '@/utils/supabase/auth';

import SignupForm from './signup-form';

export default async function SignupPage() {
  await redirectIfAuthenticated();

  return (
    <div
      className="relative flex min-h-screen flex-col items-center justify-center bg-gradient-to-br from-slate-50 to-slate-100 p-4">
      <SignupForm signUpAction={signUp}/>
    </div>
  );
}
