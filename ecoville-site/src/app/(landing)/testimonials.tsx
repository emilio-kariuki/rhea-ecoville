"use client";
import Image from "next/image";
import Apple from "@/assets/apple.svg";
import Google from "@/assets/google.svg";
import {
    Carousel,
    CarouselContent,
    CarouselItem,
    CarouselNext,
    CarouselPrevious,
  } from "@/components/ui/carousel";
import { Card } from "@/components/ui/card";
import Autoplay from "embla-carousel-autoplay";
import { inter, } from "@/lib/fonts";


  
export function Testimonials() {
  return (
    <div className="flex flex-col items-center justify-center gap-10 py-20">
      <div className="flex flex-col items-center ">
        <h1 className="font-bold text-[65px] leading-none text-[#224722]">
          What people are saying
        </h1>
        <div className="w-fit flex flex-row gap-10 mt-16">
            <StoreCard
                image={Apple}
                alt="Apple"
                title="App Store"
                rating="4.9"
            />
            <StoreCard
                image={Google}
                alt="Google"
                title="Google Play"
                rating="4.9"
            />
        </div>
        <CarouselTestimonial />
      </div>
    </div>
  );
}

function StoreCard({ ...props }) {
  return (
    <div className="w-fit flex flex-row items-center justify-center gap-2 bg-[#D9E7CB] px-6 py-3 rounded-[30px]">
      <Image
        src={props.image}
        alt={`${props.alt}`}
        className="rounded-md h-[30px] w-[30px] object-contain"
      />
      <h4 className="w-fit font-medium text-[22px] leading-tight  text-[#224722]">
        {props.title}
      </h4>
      <h4 className="w-fit font-bold text-[22px] leading-tight  text-[#224722]">
        {props.rating}
      </h4>
    </div>
  );
}

const testimonials = [
    {
      description:
        "We export passion fruit, It is a good source of vitamins and minerals such as Vitamin C, Vitamin A, and Vitamin B. It is also a good source of antioxidants, which can help protect the body against damage from free radicals.We package it to customer Specification.",
      title: "Emilio Kariuki",
    },
    {
      description:
        "We export chilli peppers,They are an excellent source of Vitamin C, Vitamin A, and Vitamin K, as well as various minerals and antioxidants. Eating chili peppers can help boost the immune system, promote healthy skin, and improve vision and eye health.We package it to customer Specification.",
      title: "Emilio Kariuki",
    },
    {
      description:
        "We export Sugar snap,They are a good source of vitamins and minerals such as Vitamin C, Vitamin K, Vitamin A and Vitamin B. They are also a good source of fiber which helps in digestion and weight management.We package it to customer Specification.",
      title: "Emilio Kariuki",
    },
];


export function CarouselTestimonial() {
    return (
      <Carousel
        opts={{
          align: "start",
          loop: true,
        }}
        plugins={[
          Autoplay({
            delay: 2000,
          }),
        ]}
        className="w-full flex flex-col py-20 px-40 gap-10 items-center justify-center bg-[#E7EDDE] rounded-[20px]"
      >
        <CarouselContent>
          {testimonials.map((testimonials, index) => (
            <CarouselItem
              key={index}
              className="lg:basis-1/2 md:basis-1/2 sm:basis-1/2"
            >
              <div className="p-1">
                <Card className="bg-[#ffffff] rounded-[20px]">
                  <TestimonialCard testimonial={testimonials} />
                </Card>
              </div>
            </CarouselItem>
          ))}
        </CarouselContent>
      </Carousel>
    );
  }
  

  function TestimonialCard({ testimonial }: { testimonial: any }) {
    return (
      <div
        className={`flex flex-col  min-h-[200px] justify-start items-start bg-transparent rounded-[10px] p-[15px] bg-[#ffffff] `}
      >
        <p
          className={`text-black text-[22px] font-semibold mb-8${inter.className}`}
        >
          {testimonial.title}
        </p>
        <p
          className="font-medium text-[16px] mt-2 text-[#000000]"
        >
          {testimonial.description}
        </p>
      </div>
    );
  }