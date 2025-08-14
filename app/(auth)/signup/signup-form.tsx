'use client';

import {FormEvent, useState} from 'react';

import {useRouter} from 'next/navigation';

import {motion} from 'framer-motion';

import {Chrome, Eye, EyeOff, Github, Loader2} from "lucide-react";

import {Input} from '@/components/ui/input';
import {Label} from '@/components/ui/label';
import {Button} from '@/components/ui/button';
import {Alert, AlertDescription} from '@/components/ui/alert';
import {Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle} from '@/components/ui/card';

export default function SignupForm({
                                     signUpAction
                                   }: {
  signUpAction: (credentials: {
    name: string;
    email: string;
    username: string;
    password: string;
    confirmPassword: string;
  }) => Promise<{ error?: string; success?: boolean }>;
}) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const router = useRouter();

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const result = await signUpAction({
        name,
        email,
        username,
        password,
        confirmPassword
      });

      if (result?.error) {
        setError(result.error);
      } else if (result?.success) {
        router.push('/');
      }
    } catch (err) {
      setError('Ocurrió un error desconocido.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
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
              Crear Cuenta
            </CardTitle>
            <CardDescription className="text-center">
              Completa el formulario para registrarte
            </CardDescription>
          </CardHeader>

          <CardContent className="grid gap-4">
            {error && (
              <Alert variant="destructive">
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="name">Nombre</Label>
                <Input
                  id="name"
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Tu nombre"
                  required
                  className="focus-visible:ring-2 focus-visible:ring-offset-2"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="email">Correo electrónico</Label>
                <Input
                  id="email"
                  name="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="tu@correo.com"
                  required
                  className="focus-visible:ring-2 focus-visible:ring-offset-2"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="name">Usuario</Label>
                <Input
                  id="username"
                  type="text"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  placeholder="Tu Usuario"
                  required
                  className="focus-visible:ring-2 focus-visible:ring-offset-2"
                />
              </div>


              <div className="space-y-2 relative">
                <Label htmlFor="password">Contraseña</Label>
                <div className="relative">
                  <Input
                    id="password"
                    name="password"
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="••••••••"
                    required
                    minLength={6}
                    className="focus-visible:ring-2 focus-visible:ring-offset-2 pr-10"
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? (
                      <EyeOff className="h-4 w-4 text-muted-foreground"/>
                    ) : (
                      <Eye className="h-4 w-4 text-muted-foreground"/>
                    )}
                    <span className="sr-only">
                    {showPassword ? "Ocultar contraseña" : "Mostrar contraseña"}
                  </span>
                  </Button>
                </div>
              </div>

              <div className="space-y-2 relative">
                <Label htmlFor="confirmPassword">Confirmar Contraseña</Label>
                <div className="relative">
                  <Input
                    id="confirmPassword"
                    name="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    placeholder="••••••••"
                    required
                    minLength={6}
                    className="focus-visible:ring-2 focus-visible:ring-offset-2 pr-10"
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  >
                    {showConfirmPassword ? (
                      <EyeOff className="h-4 w-4 text-muted-foreground"/>
                    ) : (
                      <Eye className="h-4 w-4 text-muted-foreground"/>
                    )}
                    <span className="sr-only">
                    {showConfirmPassword ? "Ocultar contraseña" : "Mostrar contraseña"}
                  </span>
                  </Button>
                </div>
              </div>

              <Button type="submit" disabled={loading} className="w-full mt-2">
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin"/>}
                Registrarse
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
                O regístrate con
              </span>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4 w-full">
              <Button variant="outline" disabled={loading}>
                {loading ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin"/>
                ) : (
                  <Chrome className="mr-2 h-4 w-4"/>
                )}
                Google
              </Button>
              <Button variant="outline" disabled={loading}>
                {loading ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin"/>
                ) : (
                  <Github className="mr-2 h-4 w-4"/>
                )}
                GitHub
              </Button>
            </div>

            <p className="text-sm text-muted-foreground mt-4">
              ¿Ya tienes una cuenta?{' '}
              <Button
                variant="link"
                className="p-0 text-sm h-auto cursor-pointer"
                onClick={() => router.push('/login')}
              >
                Iniciar Sesión
              </Button>
            </p>
          </CardFooter>
        </Card>
      </motion.div>
    </>
  );
}
