import { supabase } from "./supabase.ts";

export async function updateNotification({
  title,
  content,
  userId,
}: {
  title: string;
  content: string;
  userId: string;
}) {
  const now = Date.now();
  return await supabase.from(Deno.env.get("NOTIFICATION_TABLE")!).insert({
    id: `${now}_${userId}`,
    title: title,
    description: content,
    userId: userId,
    isRead: false,
  });
}
