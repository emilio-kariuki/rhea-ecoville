import { updateNotification } from "../utilities/update_notification.ts";
import { supabase } from "../utilities/supabase.ts";
import { sendNotification } from "../utilities/send_notification.ts";
import { updateWinnersTable } from "../utilities/update_winners_table.ts";

Deno.serve(async (_) => {
  try {
    const { data } = await supabase.from(Deno.env.get("BIDDING_TABLE")!).select(
      "ecoville_user(*), ecoville_product(*), *",
    );
    for (const bid of data!) {
      console.log("data ", data)
      const currentTime = Date.now();
      console.log("currentTime ", currentTime);
      const splitEndTime = bid.ecoville_product.endBiddingTime.split(" ");
      const newDateTime = `${splitEndTime}Z`;
      const endTime = Date.parse(newDateTime);
      console.log("endTime ", endTime);
      const minutes = Math.ceil(
        (endTime - currentTime) / (1000 * 60),
      ) - 180;
      console.log("minutes ", minutes);
      if (
        minutes <= 0 && bid.ecoville_product.currentPrice === bid.price &&
        bid.ecoville_product.allowBidding === true
      ) {
        const title = "You are the winner!";
        const content =
          "Congratulations! You are the winner of the bidding. Please check your email for further information.";
        const token = bid.ecoville_user.token;
        await sendNotification(
          {
            title: title,
            content: content,
            token: token,
          },
        );
        await supabase.from(Deno.env.get("PRODUCTS_TABLE")!).update({
          allowBidding: false,
        }).eq("id", bid.ecoville_product.id);
        await updateNotification({
          title: title,
          content: content,
          userId: bid.ecoville_user.id,
        });
        await updateWinnersTable({
          biddingId: bid.id,
          userId: bid.ecoville_user.id,
        });
      } else if (minutes <= 0) {
        return new Response(
          JSON.stringify({ message: "Bid has ended." }),
          { headers: { "Content-Type": "application/json" } },
        );
      } else {
        return new Response(
          JSON.stringify({ message: "Bid is still running." }),
          { headers: { "Content-Type": "application/json" } },
        );
      }
    }
    return new Response(
      JSON.stringify({
        message: "Winner Notification bid has been called",
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
