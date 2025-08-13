import {NextResponse} from 'next/server';
import {signIn} from "@/utils/supabase/helper";

export async function POST(req: Request) {
  try {
    const {email, password} = await req.json();

    const userData = await signIn(email, password);

    return NextResponse.json(userData, {status: 200});
  } catch (err: unknown) {
    if (err instanceof Error) {
      return NextResponse.json({message: err.message}, {status: 400});
    } else {
      return NextResponse.json({message: "An unknown error occurred."}, {status: 500});
    }
  }
}
