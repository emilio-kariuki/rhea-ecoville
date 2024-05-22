import { updateNotification } from "../utilities/update_notification.ts";
import { sendNotification } from "../utilities/send_notification.ts";
import { supabase } from "../utilities/supabase.ts";

Deno.serve(async (_) => {
  try {
    const { data } = await supabase.from("ecoville_bidding").select(
      "ecoville_user(*), ecoville_product(*), *",
    );
    for (const bid of data!) {
      if (bid.ecoville_product.currentPrice === bid.price) {
        const title = "You are the highest Bidder!";
        const content =
          "Congratulations! You are now the highest bidder. If you are the highest bidder when the auction ends, you will win the item. Good luck!";
        const token = bid.ecoville_user.token;
        await sendNotification(
          {
            title: title,
            content: content,
            token: token,
          },
        );
        await updateNotification({
          title: title,
          content: content,
          userId: bid.ecoville_user.id,
        });
      } else {
        return new Response(
          JSON.stringify({ message: "Bid is still running." }),
          { headers: { "Content-Type": "application/json" } },
        );
      }
    }
    return new Response(
      JSON.stringify({
        message: "Notification bid has been called",
      }),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.log(error);
    return new Response(
      JSON.stringify(error),
      { headers: { "Content-Type": "application/json" } },
    );
  }
});
