'use client';

import { useEffect, useState } from 'react';
import {
  useConnect,
  useAccount,
  useRequestSignature,
  Network,
  useDisconnect
} from '@puzzlehq/sdk';
import { toast } from "sonner";
import { useRouter } from 'next/navigation';
import {
  Card,
   CardContent,
   CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import {   Loader2 } from 'lucide-react';
 
export function WalletConnect() {
  const [isProcessing, setIsProcessing] = useState(false);
  const [currentStep, setCurrentStep] = useState<
    'idle' | 'connecting' | 'signing' | 'authenticating'
  >('idle');
 
  const router = useRouter();

   // Puzzle wallet hooks
  const { account } = useAccount();

  const {
    connect,
    error: connectError,
   } = useConnect({
    dAppInfo: {
      name: 'My first Dapp',
      description:
        'Privacy-preserving Dapp',
      iconUrl: '/favicon.ico',
    },
    permissions: {
      programIds: {
        [Network.AleoMainnet]: ['dapp_3_imports_1.aleo'],
        [Network.AleoTestnet]: ['dapp_3_imports_1.aleo']
      }
    }
  });
 
  const { disconnect } = useDisconnect();

  const {
    requestSignature,
      error: requestSignatureError
  } = useRequestSignature({
    message: account?.address ?? 'My first Dapp Authentication'
  });

  // Handle errors from wallet interactions
  useEffect(() => {
    if (connectError) {
      toast.error(`Connection error: ${connectError}`);
      setIsProcessing(false);
      setCurrentStep('idle');
    }

    if (requestSignatureError) {
      toast.error(`Signature error: ${requestSignatureError}`);
      setIsProcessing(false);
      setCurrentStep('idle');
    }
  }, [connectError, requestSignatureError]);
  // Main authentication flow
  const handleWalletConnect = async () => {
    if (isProcessing) return;

    setIsProcessing(true);

    try {
      // If account is already connected, skip to signature request
      if (account?.address) {
        setCurrentStep('signing');
        await requestSignature();
              setIsProcessing(false);

        // The signature response will be handled in the useEffect above
      } else {
        // Connect wallet first
        setCurrentStep('connecting');
        await connect();
        // Wait a moment for the connection to be established
        await new Promise((resolve) => setTimeout(resolve, 100));

        // After connection, request signature
        if (account?.address) {
          setCurrentStep('signing');
          await requestSignature();
                setIsProcessing(false);
        }
      }
            setIsProcessing(false);

    } catch (error) {
      console.error('Authentication flow error:', error);
 
      toast.error('Authentication process failed');
      setIsProcessing(false);
      setCurrentStep('idle');
    }
  };
const handleDisconnect = async () => {
  if (isProcessing) return;
  setIsProcessing(true);
  await disconnect();
  setIsProcessing(false);
  setCurrentStep('idle');
};
  // Check if wallet is already connected on component mount and load user data
  useEffect(() => {
 
    // If wallet is already connected, update the button state
    if (account?.address) {
      console.log('Wallet already connected:', account.address);
    }
  }, [account]);

   // Button text based on current step
  const getButtonText = () => {
    switch (currentStep) {
      case 'connecting':
        return 'Connecting Wallet...';
      case 'signing':
        return 'Waiting for Signature...';
      case 'authenticating':
        return 'Authenticating...';
      default:
        return account
          ? 'Disconnect Wallet'
          : 'Connect Puzzle Wallet';
    }
  };

  return (
    <Card className="w-full bg-white max-w-md mx-auto shadow-lg border border-slate-200  ">
      <CardHeader className="text-center pb-8">
        <div className="relative">
          <CardTitle className="text-3xl font-bold bg-gradient-to-r from-blue-600 to-blue-800 bg-clip-text text-transparent">
           Aleo Dapp Boilerplate
          </CardTitle>
        </div>
        <CardDescription className="text-base text-slate-600">
          Privacy-preserving dapp
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="text-center">
          <p className="text-lg text-slate-700">
            {account?.address
              ? `${account?.network} Connected: ${account.shortenedAddress}`
              : 'Please connect your Puzzle Wallet to continue.'}
          </p>
        </div>
      </CardContent>

      <CardFooter className="pt-6">
        {account?.address ? (
          <Button
            onClick={handleDisconnect}
            disabled={isProcessing}
            className={`w-full py-6 text-base font-medium rounded-xl transition-all duration-200 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 shadow-md hover:shadow-lg disabled:opacity-70 disabled:cursor-not-allowed`}
          >
            {isProcessing && <Loader2 className="mr-2 h-5 w-5 animate-spin" />}
            Disconnect Wallet
          </Button>
        ) : null}
        {!account?.address && (
        <Button
          onClick={handleWalletConnect}
          disabled={isProcessing}
          className={`w-full py-6 text-base font-medium rounded-xl transition-all duration-200 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 shadow-md hover:shadow-lg disabled:opacity-70 disabled:cursor-not-allowed`}
        >
          {isProcessing && <Loader2 className="mr-2 h-5 w-5 animate-spin" />}
          {getButtonText()}
        </Button>
        )}
      </CardFooter>
    </Card>
  );
}
