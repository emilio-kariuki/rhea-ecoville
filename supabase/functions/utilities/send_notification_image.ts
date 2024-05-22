import { FcmClient } from "https://deno.land/x/firebase_messaging@1.0.4/mod.ts";
const serviceAccount = {
  "type": "service_account",
  "project_id": "ecoville-picsa",
  "private_key_id": Deno.env.get("FIREBASE_ADMIN_PRIVATE_KEY_ID")!,
  "private_key":
    "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC4eIEJFQ+2A3Jo\nZSnS1FDjIK8Ex/zInZbaMUFaRlu52jk+sxx3MlLhQe2EvqP9dCBdckoRovmCUJEG\ne1qGvqiSY5UMA6e181r2pPJkYawPvxwxfPeVfZ4jycovAu0iy0+yKge55EBKR9yu\nzUgCjPo4TkQ87LOe6b08iWRfcVrEOW9rHhhLAqXykUMgmZdyc2iMK+Loo4YFDZdF\nMD+BY+EQatn6uNCR7xoqf1iciw/zrf73JKQj7CeckWlr9etAwuyFwunL4cFar/zt\nnqDqrFSVvu6LdPzQAx99Tk8owpNUf3Nc1YHYf6AeWLFZBAVMmI9L22DxfCtdlKAR\nAM4OQ6GjAgMBAAECggEAPEZzsyoEli6OJXpYriDdxTkatu85s7t6XRUXC45Nzm51\nof0YYgI5fozyNRutrdVR9fawKQ8dg+0bVgjcTYbiweJ0Axb2p8c6g7jl0tLvS73g\nUnNI2rnPAFahD7dfEK1p/wcoux7PuvW8MAm3a83wvJEmTtnw3w303WDvQRhi1hZ3\nwcZfIthiplN1iyYhU/bM62D+lq0i9PAS0zrqbpLZV+4poH/09bIb7PRLtzkEwSOm\nvniQaT5povxqiEKmEOuWPXCCOWatTeirOXSnoryEXXOJozMjjK9wfxaI/bNt+8x+\nc/DcwSRb3OQEeceAxOGEdt2bg/f/A2GtKePqscNc8QKBgQDsfes8fqmPXP3ma0ZT\nhEdv1VA6ybuzgYH3pQdyvlr95gGPZV39ts2LYzpvxFWoTFLy2HOIL/gFp2T9+j+u\no5LT6VJFQ+V5854etDlZvK0odhTAxB9Eb4RUGpduuQXfHkSz64jqgfkTK5MWeYVF\nOZeAt+h+obSviTrUqXgC3TS8LwKBgQDHsAlRFYp90UCvMGptlGnjBrF06QpgRd7I\nr8yh5edLngtCnRUiN1BONbR2tLfO3psaP74/uVdlDiJuZqCqmnFCgyibbDc1JxBr\ngSZVv3X9Z5whgRRFTVsVVOf8bolfs13YFpIKS5XplUNOJkqrLDOP1B8KXYJZblgd\nRqtuhZoQzQKBgQCviWODGq03CZo4XuXrdeMkglwz1qtpOTbEH42gwOR/UytTSbVz\nbi2xSa0FauD9s/FZ6goPSzO41qBi2E5OjYGdo7D6UsRROd/jAHkVP7PztXn//1MK\nFBBP8RD4EYPnMeti9PBCyMidTxm1c+vVD0OCOn/rBpI8PQsa8NNwpMrQ5wKBgQCO\nmA9fHoHB7L5DG9C0JWojmzD3aj5llx9KsfbvmWu8XMRvshpYT6WB4+nVZqFnESEy\n8lfZy3E0EY7WxWRvz0+Xjm9d5T3bL+USz6vfSZRo+ybL6g/emSm0pufuI8TnWP9n\ngl6RCX6oyVTBpqhlaW/8gh4UWcfuMtSrOz7J8o+c9QKBgQCiCipvB7brkkK51l1R\nF/9dw+RZeo7T1uc7Vy801KS/GrNEZasR0kzSCmlWlcH2bjbgYzxq95TP9L6/ax4B\nO7VLFDTKP5PYUlHzEcSnpQYi1F539wz0mL34Z3qIQyOR6X1zsXcazWN5cSzefSHz\nx3JRnHKcSBfe6UpvB/vAt8wvJg==\n-----END PRIVATE KEY-----\n",
  "client_email": Deno.env.get("FIREBASE_ADMIN_CLIENT_EMAIL")!,
  "client_id": Deno.env.get("FIREBASE_ADMIN_CLIENT_ID")!,
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": Deno.env.get("FIREBASE_ADMIN_CLIENT_X509_CERT_URL"),
  "universe_domain": "googleapis.com",
};

const fcmClient = new FcmClient(serviceAccount);

export async function sendNotificationWithImage({
  title,
  content,
  image,
  token,
}: {
  title: string;
  content: string;
  image: string;
  token: string;
}) {
  const notification = {
    notification: {
      title: title,
      body: content,
    },
    android: {
      notification: {
        imageUrl: image,
      },
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
