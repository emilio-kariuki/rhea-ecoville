"use client"

import Image from "next/image";
import { Hero } from "./hero";
import { About } from "./about";
import { Testimonials } from "./testimonials";
import { More } from "./more";

export default function Home() {
  return (
    <main className="min-h-screen bg-[#E7EDDE]">
      <Hero />
      <About />
      <Testimonials />
      <More />
    </main>
  );
}
