import { supabase } from "./supabase.ts";

export async function updateWinnersTable({
  biddingId,
  userId,
}: {
  biddingId: string;
  userId: string;
}) {
  const now = Date.now();
  return await supabase.from(Deno.env.get("WINNERS_TABLE")!).insert({
    id: `${now}_${userId}`,
    biddingId: biddingId,
    userId: userId,
  });
}
