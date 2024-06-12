
import { supabase } from "../utilities/supabase.ts";

Deno.serve(async (req) => {
  const { products } = await req.json()
  for(const product of products) {
     await supabase.from("ecoville_product").update({
      sold: true
    }).eq("id", product);
  }
  return new Response(
    JSON.stringify(
      { message: "Products have been purchased." },
    ),
    { headers: { "Content-Type": "application/json" } },
  )
})
