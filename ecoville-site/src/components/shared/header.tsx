"use client";

export default function Header() {
  return (
    <div className="flex flex-row justify-between items-center p-4 bg-[#E7EDDE]">
      <h3 className="font-medium text-[16px] text-[#224722]">Support</h3>
      <h3 className="font-bold text-[30px] text-[#224722]">Ecoville</h3>
      <div className="bg-transparent border-[1px] border-[#224722] rounded-[20px] px-4 py-1">
        <p className="font-medium text-[16px] text-[#224722]">Get the app</p>
      </div>
    </div>
  );
}
