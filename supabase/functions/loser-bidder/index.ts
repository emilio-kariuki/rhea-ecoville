import { updateNotification } from "../utilities/update_notification.ts";
import { supabase } from "../utilities/supabase.ts";
import { sendNotification } from "../utilities/send_notification.ts";

Deno.serve(async (_) => {
  try {
    const { data } = await supabase.from("ecoville_bidding").select(
      "ecoville_user(*), ecoville_product(*), *",
    );
    for (const bid of data!) {
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
        minutes <= 0 &&
        minutes > -1450
        &&
        bid.ecoville_product.allowBidding === false
        && bid.ecoville_product.currentPrice !== bid.price
      ) {
        const title = "You did not win the bid!";
        const content = "Check out the next auction to try your luck again.";
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
        message: "Lost Notification bid has been called",
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
