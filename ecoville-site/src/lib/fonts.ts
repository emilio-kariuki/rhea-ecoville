import { Inter, Quicksand } from "next/font/google";
import localFont from "next/font/local";

const inter = Inter({ subsets: ["latin"] });


const quicksand = Quicksand({ subsets: ["latin"], weight: ["600"] });

export { inter, quicksand };
