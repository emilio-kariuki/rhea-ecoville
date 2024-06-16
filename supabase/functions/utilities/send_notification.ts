import { FcmClient } from "https://deno.land/x/firebase_messaging@1.0.4/mod.ts";
const serviceAccount = {
  "type": "service_account",
  "project_id": "ecoville-eville",
  "private_key_id": Deno.env.get("FIREBASE_ADMIN_PRIVATE_KEY_ID")!,
  "private_key":
    "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDW3X3p1O8wN8sV\nlEjx2DNTiu+/r1t0ZBUQJ4XkzNAa5A11bp+op7Sa3m4k/Qk+Lr5PyF0CdmiLruCa\n7l17zoRrASSMGzXy8mXnO7Ey63eef7E9UGXa7xrXGbCqvfLhIs5uNT40yvajoPPI\nRR05aX05SzFaxX9RO07l1//qk6XOIPMhETEM6b6aPKfwNxdU2sBm77/I0z0GWw4U\nKtEhIMUqzbKR8Wv9DXPrg3GQXYqD3sS/8roUVXsFYi36Au3GqbvE1md0qAtNcm9l\n6EVgdb2lRI5gBgvRN9I+otl1ItQZbLpXD1yvhv2rA8+nB6V+QIWhf1XJ1gc9n23O\nY/A7ULrJAgMBAAECggEADobRX/vwTetqag4+nkc2ink+u1Abl/Nk7yoqOxf+dor2\nPqXDhUS4CQPCdkgQlhPVSbyV+Tgl2lJw8gNCmRUTI87jIyvQdRlJUB2w3cHzXOkX\ng7nfS7LVtuGQQwLuRvqyR9uGq01mPmrVKzRCWmLU6gjjkIEAxMOvPQqM+AA9JKyQ\nMcLvyzWPuEE9Tn4AzVvHLZYTK8VVF73ZUko9Fcmr2MyWYnoyDn01MnBY4ZWCpryB\nbpeH1DCFHwz44BTW9lCf5ap3nAaUuZVSED65lcDLFNH7ppnMEYSgI1b0qucXQuKq\nurl56Qzw6wXfean/6f8U+R3YC2i7zN9CYQafiv3nOQKBgQD3LKY/SvFyNRHGqZsJ\nQxu3Zr4VYiQS2kwSTFLAg5yDHHeHDERfLup1O/GokuefounTT4B0OLjiW6JV0kWO\nDFZh8vstcWfG29AWbcduO/LhiiediKtYg/YhnWBK3Zek7Z99UaFwIhHM5UNE/5xI\nX8G6e1kq3mHMCXGwLWUXf7k5hQKBgQDeiYNhfWgcS/+VDf1THuosVF659i7F4uWj\n9hdKK1MwIKpSNbBU62A1WoTuNkfnYOx1nhyQu9LocHfArOmtPH31b05tdC8wfeFY\nRarjk1gQ9xrLipdMc0M7Nb3GibDxD/Aoa52DyrNGDkO+V8tp1Iz4TMOohZY7A8cE\noUFfbt39dQKBgQDGJfsYXkH05mpbsnfhEvVTL4BOsCBvJKU7PghQ4LFFwjpn/wOI\nspmuZeGy3CHnLbj5d5Bom1hLzl3zIuAzodxWJW4K3hDtsCW+9T6dNl3dRN3BQmDq\nUs+r3vfkzIPW6c+jrR8YP5e5hElLNQbaVjl9/4hZ/3CzGxcSvzF9hxy76QKBgQCU\nA5bVExpaJ9pZA7MIxDkxPvS6b5nwmNfw1E/tTx/HlRJ0F62u7ddR5WEhKA1vQjJE\nkOOjCKphW9zq1JegV+nXgy8A8hQpBrEJi1z8fRZIQnMaCpZTjR6clUQid5au39D2\nsY1VCU9wOzCnu7FaNLuGs1g4EJI5smt/EtpuZUlVuQKBgQDFfIuplFeNpa8mNRZL\nB4ncyIJdy4imf60vVBgxj7M5aPWWADh469N6YOn3xgmWfoLMQSiH113IkcbKmohz\nppSIwa1b2ff6XxBzKeEHKaGuSkaZITwS/v6bpOimV77+c6FoejRQGTUwRChDMWVX\ny1EktovhkFWVVNQXMCl2ZhfkGA==\n-----END PRIVATE KEY-----\n",
  "client_email": Deno.env.get("FIREBASE_ADMIN_CLIENT_EMAIL")!,
  "client_id": Deno.env.get("FIREBASE_ADMIN_CLIENT_ID")!,
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": Deno.env.get("FIREBASE_ADMIN_CLIENT_X509_CERT_URL"),
  "universe_domain": "googleapis.com",
};

const fcmClient = new FcmClient(serviceAccount);

export async function sendNotification({
  title,
  content,
  token,
}: {
  title: string;
  content: string;
  token: string;
}) {
  const notification = {
    notification: {
      title: title,
      body: content,
    },
    token: token,
  };
  try {
    const message = await fcmClient.sendNotification(notification);
    console.log("notification message ", message);
  } catch (error) {
    console.error(error);
  }
}
