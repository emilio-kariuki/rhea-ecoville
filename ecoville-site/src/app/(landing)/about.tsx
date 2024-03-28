"use client";
import Image from "next/image";
import Watering from "@/assets/watering.jpg";
import { BriefcaseMedical, Sun, Scan, Droplet } from "lucide-react";
export function About() {
  return (
    <div className="flex flex-col items-center justify-center gap-10 py-32">
      <div className=" w-fit flex flex-row gap-32 items-start justify-center">
        
         <div className="relative">
         <Image
          src={Watering}
          alt="Watering"
          className=" lg:h-[550px] lg:w-[500px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-br-[250px]"
        />
          <div className="absolute flex flex-row items-center justify-center top-10 left-5 gap-4  bg-[#ffffff]  py-4 px-4 rounded-[50px]">
            <Droplet size={35} color="#1C4723" />
            <p className="text-[#1C4723] text-[20px] font-medium ">
              Water twice a week
            </p>
          </div>
        </div>

        <div className="flex flex-col items-start">
          <h3 className="font-medium text-[18px] w-[530px] mx-w-[530px] mt-8 text-[#224722]">
            Unique care schedules
          </h3>
          <h1 className="font-bold text-[50px] w-[300px] mx-w-[300px] leading-none text-[#224722] mt-5">
            Smart care reminders
          </h1>
          <p className="font-medium text-[20px] w-[480px] mx-w-[480px] mt-8 text-[#224722]">
            Are you not sure when it’s time to water your plants? Planta knows
            when! Just add them to the app and get notified when it’s time to
            water, fertilize, mist, clean (yes, it’s a thing) and repot!
          </p>
          <div className="bg-[#224722] rounded-[40px] py-5 px-12 mt-10 ">
            <h3 className="text-[#C4DEA9] font-medium text-[17px]">
              Download now
            </h3>
          </div>
        </div>
      </div>
      {/* //* second container */}
      <div className=" w-fit flex flex-row gap-32 items-center justify-center mt-28">
        <div className="flex flex-col items-start">
          <h3 className="font-medium text-[18px] w-[530px] mx-w-[530px] mt-8 text-[#224722]">
            Scan your plant
          </h3>
          <h1 className="font-bold text-[50px] w-[300px] mx-w-[300px] leading-none text-[#224722] mt-5">
            Plant identification
          </h1>
          <p className="font-medium text-[20px] w-[480px] mx-w-[480px] mt-8 text-[#224722]">
            Maybe you are not sure which plant you have? You can just take a
            picture of it and we will instantly let you know. With Plantas plant
            scanner you can scan all your house plants to find out the plants
            name and how to care for them.
          </p>
          <div className="bg-[#224722] rounded-[40px] py-5 px-12 mt-10 ">
            <h3 className="text-[#C4DEA9] font-medium text-[17px]">
              Download now
            </h3>
          </div>
        </div>
        <div className="relative">
          <Image
            src={Watering}
            alt="Watering"
            className=" lg:h-[550px] lg:w-[550px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-full"
          />
          <div className="absolute flex flex-row items-center justify-center top-20 right-200 gap-4  bg-[#ffffff]  py-4 px-4 rounded-[50px]">
            <Scan size={35} color="#1C4723" />
            <p className="text-[#1C4723] text-[20px] font-medium ">
              Scan your plant
            </p>
          </div>
        </div>
      </div>
      {/* //* third container */}
      <div className=" w-fit flex flex-row gap-32 items-center justify-center mt-28">
        
        <div className="relative">
        <Image
          src={Watering}
          alt="Watering"
          className=" lg:h-[550px] lg:w-[550px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-br-[300px] rounded-tr-[300px]"
        />
          <div className="absolute flex flex-row items-center justify-center bottom-10 left-5 gap-4  bg-[#ffffff]  py-4 px-4 rounded-[50px]">
            <Sun size={35} color="#1C4723" />
            <p className="text-[#1C4723] text-[20px] font-medium ">
              Place in part sun
            </p>
          </div>
        </div>
        <div className="flex flex-col items-start">
          <h3 className="font-medium text-[18px] w-[530px] mx-w-[530px] mt-8 text-[#224722]">
            Find the right light
          </h3>
          <h1 className="font-bold text-[50px] w-[300px] mx-w-[300px] leading-none text-[#224722] mt-5">
            Light meter
          </h1>
          <p className="font-medium text-[20px] w-[480px] mx-w-[480px] mt-8 text-[#224722]">
            Would you like to put a plant in a bathroom without windows? Some
            plants prefer shade and some are sun-lovers. Get to know which
            plants are suitable in your home based on the different light
            conditions of your rooms.
          </p>
          <div className="bg-[#224722] rounded-[40px] py-5 px-12 mt-10 ">
            <h3 className="text-[#C4DEA9] font-medium text-[17px]">
              Download now
            </h3>
          </div>
        </div>
      </div>
      {/* //* fourth container */}
      <div className=" w-fit flex flex-row gap-32 items-center justify-center mt-28">
        <div className="flex flex-col items-start">
          <h3 className="font-medium text-[18px] w-[530px] mx-w-[530px] mt-8 text-[#224722]">
            Plant doctor
          </h3>
          <h1 className="font-bold text-[50px] w-[300px] mx-w-[300px] leading-none text-[#224722] mt-5">
            Dr. Planta
          </h1>
          <p className="font-medium text-[20px] w-[480px] mx-w-[480px] mt-8 text-[#224722]">
            Are your plants not feeling good? Dr. Planta can help you figure out
            what’s wrong and set up a treatment plan.
          </p>
          <div className="bg-[#224722] rounded-[40px] py-5 px-12 mt-10 ">
            <h3 className="text-[#C4DEA9] font-medium text-[17px]">
              Download now
            </h3>
          </div>
        </div>
        <div className="relative">
          <Image
            src={Watering}
            alt="Watering"
            className=" lg:h-[550px] lg:w-[550px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-[150px]"
          />
          <div className="absolute flex flex-row items-center justify-center top-20 right-100 gap-4  bg-[#ffffff]  py-4 px-4 rounded-[50px]">
            <BriefcaseMedical size={35} color="#1C4723" />
            <p className="text-[#1C4723] text-[20px] font-medium ">
              Change plant location
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
