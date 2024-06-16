import { sendNotification } from "../utilities/send_notification.ts";
import { supabase } from "../utilities/supabase.ts";

Deno.serve(async (req) => {
  const { products, user } = await req.json();
  for (const product of products) {
    await supabase.from("ecoville_product").update({
      sold: true,
    }).eq("id", product);
  }

  const {data} = await supabase.from("ecoville_user").select().eq("id", user);
  console.log("userData ", data[0]);
  const token = data[0].token;
  console.log("token ", token);
  await sendNotification(
    {
      title: "You have purchased a product!",
      content:
        "Congratulations! You have successfully purchased a product. Thank you for shopping with us!",
      token: token,
    },
  );
  return new Response(
    JSON.stringify(
      { message: "Products have been purchased." },
    ),
    { headers: { "Content-Type": "application/json" } },
  );
});
