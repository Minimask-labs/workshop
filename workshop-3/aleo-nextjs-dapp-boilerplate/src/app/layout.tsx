'use client';
import React, { useMemo } from 'react';
import { Inter } from 'next/font/google';
import './globals.css';
import { PuzzleWalletProvider } from '@puzzlehq/sdk';
import { Toaster } from '@/components/ui/sonner';

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        {/* Script to prevent flickering when loading in dark mode */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
            (function() {
              document.documentElement.classList.add('dark');
            })();
          `
          }}
        />
      </head>
      <body className={inter.className}>
        <PuzzleWalletProvider>{children}</PuzzleWalletProvider>
        <Toaster />
      </body>
    </html>
  );
}

 