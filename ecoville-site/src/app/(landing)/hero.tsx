"use client";
import Image from "next/image";
import Landing from "@/assets/landing.png";
import Apple from "@/assets/apple.svg";
import PlayStore from "@/assets/playstore.svg";
import { Plus, Home, Leaf, Search, Compass } from "lucide-react";
export function Hero() {
  return (
    <div className="flex flex-row items-center justify-center gap-10 py-20">
      <div className=" w-fit flex flex-col items-start ">
        <h1 className="font-bold text-[110px] w-[40px] mx-w-[40px] leading-none text-[#224722]">
          Keep your plants alive
        </h1>
        <p className="font-medium text-[20px] w-[530px] mx-w-[530px] mt-8 text-[#224722]">
          Individual care schedule and reminders for your plants,
          recommendations, step by step guides, identification, light meter and
          more. Keep your plants alive with Planta!
        </p>
        <div className="flex flex-row gap-5">
          <StoreButton image={Apple} alt="Apple" title="App Store" />
          <StoreButton image={PlayStore} alt="PlayStore" title="Google Play" />
        </div>
      </div>
      <div className="relative">
        <Image
          src={Landing}
          alt="Landing2"
          className="rounded-md lg:h-[800px] lg:w-[600px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-contain"
        />
        <div className="absolute flex flex-row items-center justify-center top-[400px] right-10  bg-[#F2E6C3]  py-3 px-3 rounded-[50px]">
          <div className="bg-[#224722] rounded-full p-1 mr-4">
            <Plus size={40} color="#E0FFC0" />
          </div>
          <h3 className="justify-center font-normal text-[20px] text-[#3e5a3c]">
            Add a plant
          </h3>
        </div>
        <div className="absolute flex flex-row items-center justify-center top-60 left-16  bg-[#1C4723]  py-12 px-3 rounded-[30px]">
          <h3 className="justify-center font-bold text-[30px] text-[#D9F8B9]">
            Ecoville
          </h3>
        </div>
        <div className="absolute flex flex-row items-center justify-center gap-10 bottom-[120px] right-1  bg-[#C4DEA9]  py-6 px-8 rounded-[50px]">
          <Home size={28} color="#000000" />
          <Leaf size={28} color="#000000" />
          <Plus size={28} color="#000000" />
          <Search size={28} color="#000000" />
          <Compass size={28} color="#000000" />
        </div>
      </div>
    </div>
  );
}

function StoreButton({ ...props }) {
  return (
    <div className="w-fit flex flex-row items-center justify-start mt-10 border-[1px] border-[#224722] px-5 py-1 rounded-[5px]">
      <Image
        src={props.image}
        alt={`${props.alt}`}
        className="rounded-md h-[50px] w-[50px] object-contain"
      />
      <div className="w-fit flex flex-col ">
        <h4 className="w-fit font-medium text-[12px] leading-none  text-[#224722]">
          Download on the
        </h4>
        <h4 className="w-fit font-medium text-[22px] leading-tight  text-[#224722]">
          {props.title}
        </h4>
      </div>
    </div>
  );
}
