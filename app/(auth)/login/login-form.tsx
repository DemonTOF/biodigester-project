'use client';

import {useState} from 'react';

import {useRouter} from "next/navigation";

import {motion} from 'framer-motion';

import {Chrome, Eye, EyeOff, Github, Loader2} from "lucide-react";
import {Input} from '@/components/ui/input';
import {Label} from '@/components/ui/label';
import {Button} from '@/components/ui/button';
import {Alert, AlertDescription} from '@/components/ui/alert';
import {Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle} from '@/components/ui/card';

export default function LoginForm({signInAction}: { signInAction: (email: string, password: string) => any }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showPassword, setShowPassword] = useState(false);

  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      const result = await signInAction(email, password);
      if (result?.error) {
        setError(result.error);
      }
    } catch (err) {
      setError('An unknown error occurred.');
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

              <div className="space-y-2 relative">
                <Label htmlFor="password">Contraseña</Label>
                <div className="relative">
                  <Input
                    id="password"
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="••••••••"
                    required
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

              <Button type="submit" disabled={loading} className="w-full mt-2">
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin"/>}
                Iniciar Sesión
              </Button>
            </form>
          </CardContent>

          <CardFooter className="flex flex-col items-center gap-2">
            <p className="text-sm text-muted-foreground mt-4">
              ¿No tienes una cuenta?{' '}
              <Button
                variant="link"
                className="p-0 text-sm h-auto cursor-pointer"
                onClick={() => router.push('/signup')}
              >
                Regístrate
              </Button>
            </p>
          </CardFooter>
        </Card>
      </motion.div>
    </>
  );
}
