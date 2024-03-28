"use client";
import Image from "next/image";
import Watering from "@/assets/watering.jpg";
export function More() {
  return (
    <div className="flex flex-col items-center justify-center gap-10 py-20">
      <div className="flex flex-col items-center ">
        <h1 className="font-bold text-[65px] text-center leading-none text-[#224722]">
          What plant <br></br> we got you covered!
        </h1>
        <div className="mt-10">
          <div className="flex flex-row gap-5">
            {/* first part */}
            <div className="flex flex-col gap-5">
              <div className=" w-fit flex flex-row gap-4">
                <div className="relative">
                  <Image
                    src={Watering}
                    alt="Watering"
                    className=" lg:h-[250px] lg:w-[250px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-br-[250px]"
                  />
                  <div className="absolute flex flex-row items-center justify-center top-1 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                    <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                      Cacti & Succulents
                    </p>
                  </div>
                </div>
                <div className="relative">
                  <Image
                    src={Watering}
                    alt="Watering"
                    className=" lg:h-[250px] lg:w-[400px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-[140px]"
                  />
                  <div className="absolute flex flex-row items-center justify-center top-20 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                    <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                      Vegatables
                    </p>
                  </div>
                </div>
              </div>
              <div className="relative">
                <Image
                  src={Watering}
                  alt="Watering"
                  className=" lg:h-[250px] lg:w-[660px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-bl-[140px] rounded-tr-[140px]"
                />
                <div className="absolute flex flex-row items-center justify-center top-20 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                  <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                    Vegatables
                  </p>
                </div>
              </div>
            </div>
            {/* second part */}

            <div className="flex flex-col gap-5">
              <div className="relative">
                <Image
                  src={Watering}
                  alt="Watering"
                  className=" lg:h-[250px] lg:w-[250px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-bl-[140px] rounded-tr-[50px] rounded-tl-[50px] rounded-bl-[50px]"
                />
                <div className="absolute flex flex-row items-center justify-center top-2 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                  <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                    Herbs
                  </p>
                </div>
              </div>
              <div className="relative">
                <Image
                  src={Watering}
                  alt="Watering"
                  className=" lg:h-[250px] lg:w-[250px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-br-[50px] rounded-tl-[50px] rounded-bl-[50px]"
                />
                <div className="absolute flex flex-row items-center justify-center top-2 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                  <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                    Flowering Plants
                  </p>
                </div>
              </div>
            </div>
            {/* third part */}
            <div className="relative">
              <Image
                src={Watering}
                alt="Watering"
                className=" lg:h-full lg:w-[200px] md:h-[200px] md:w-[200px] sm:h-[0px] sm:w-[0px] object-cover rounded-br-[200px]"
              />
              <div className="absolute flex flex-row items-center justify-center top-2 left-1 gap-4  bg-transparent  py-4 px-4 rounded-[50px]">
                <p className="text-[#ffffff] text-[28px] font-medium leading-tight ">
                  Orchids
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
