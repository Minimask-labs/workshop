 import {WalletConnect} from "@/components/wallet-connect/page";
 
export default function Home() {
  return (
    <div className="font-sans bg-white/40 w-full grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20">
      <main className="flex w-full flex-col gap-[32px] row-start-2 items-center sm:items-start">
        <div className="flex w-full gap-4 items-center flex-col sm:flex-row">
          <WalletConnect />
        </div>
      </main>
    </div>
  );
}
