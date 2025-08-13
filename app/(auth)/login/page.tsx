'use client';

import {FormEvent, useState} from 'react';

import {useRouter} from 'next/navigation';

import {motion} from 'framer-motion';

import {Chrome, Github, Loader2 as Spinner} from "lucide-react";

import {Input} from '@/components/ui/input';
import {Label} from '@/components/ui/label';
import {Button} from '@/components/ui/button';
import {Alert, AlertDescription} from '@/components/ui/alert';
import {Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle} from '@/components/ui/card';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const router = useRouter();

  const handleLogin = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const res = await fetch('/api/auth', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email,
          password,
        }),
      });

      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.message || 'Failed to log in');
      }

      await router.push('/dashboard');
    } catch (err) {
      if (err instanceof Error) {
        setError(err.message);
      } else {
        setError('An unknown error occurred.');
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div
      className="relative flex min-h-screen flex-col items-center justify-center bg-gradient-to-br from-slate-50 to-slate-100 p-4">
      {/* Animated background elements */}
      <motion.div
        className="absolute top-20 left-20 h-32 w-32 rounded-full bg-indigo-100/50 blur-xl"
        animate={{
          x: [0, 20, 0],
          y: [0, 30, 0],
        }}
        transition={{
          duration: 15,
          repeat: Infinity,
          repeatType: 'reverse',
        }}
      />
      <motion.div
        className="absolute bottom-20 right-20 h-40 w-40 rounded-full bg-blue-100/50 blur-xl"
        animate={{
          x: [0, -20, 0],
          y: [0, -30, 0],
        }}
        transition={{
          duration: 20,
          repeat: Infinity,
          repeatType: 'reverse',
        }}
      />

      <motion.div
        initial={{opacity: 0, y: 20}}
        animate={{opacity: 1, y: 0}}
        transition={{duration: 0.5}}
        className="w-full max-w-md"
      >
        <Card className="border-0 shadow-lg">
          <CardHeader className="space-y-1">
            <CardTitle className="text-2xl font-bold text-center">
              Bienvenido
            </CardTitle>
            <CardDescription className="text-center">
              Ingresa tu correo y contraseña para iniciar sesión
            </CardDescription>
          </CardHeader>

          <CardContent className="grid gap-4">
            {error && (
              <Alert variant="destructive">
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}

            <form onSubmit={handleLogin} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="email">Correo</Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="tu@correo.com"
                  required
                  className="focus-visible:ring-2 focus-visible:ring-offset-2"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="password">Contraseña</Label>
                <Input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="••••••••"
                  required
                  className="focus-visible:ring-2 focus-visible:ring-offset-2"
                />
              </div>

              <Button type="submit" disabled={loading} className="w-full mt-2">
                {loading && <Spinner className="mr-2 h-4 w-4 animate-spin"/>}
                Iniciar Sesión
              </Button>
            </form>
          </CardContent>

          <CardFooter className="flex flex-col items-center gap-2">
            <div className="relative w-full">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t"/>
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-background px-2 text-muted-foreground">
                  O inicia sesión con
                </span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4 w-full">
              <Button variant="outline" disabled={loading}>
                {loading ? (
                  <Spinner className="mr-2 h-4 w-4 animate-spin"/>
                ) : (
                  <Chrome className="mr-2 h-4 w-4"/>
                )}
                Google
              </Button>
              <Button variant="outline" disabled={loading}>
                {loading ? (
                  <Spinner className="mr-2 h-4 w-4 animate-spin"/>
                ) : (
                  <Github className="mr-2 h-4 w-4"/>
                )}
                GitHub
              </Button>
            </div>

            <p className="text-sm text-muted-foreground mt-4">
              ¿No tienes una cuenta?{' '}
              <Button variant="link" className="p-0 text-sm h-auto">
                Crear Cuenta
              </Button>
            </p>
          </CardFooter>
        </Card>
      </motion.div>
    </div>
  );
}
