# @computesphere/api-client

The official TypeScript client for the [ComputeSphere](https://computesphere.com) API.

## Install

```bash
npm install @computesphere/api-client
```

## Authentication

Authenticate with a **ComputeSphere access token** — an **API token** (create one
in the [console](https://console.computesphere.com) under **Settings → API
Tokens**) or an **OAuth access token**.

## Usage

```ts
import { createClient, parseProblem } from "@computesphere/api-client";

const api = createClient({
  baseUrl: "https://api.computesphere.com/api/v2",
  token: () => getAccessToken(), // return your ComputeSphere access token
});

const { data, error } = await api.GET("/regions", {
  headers: { "x-account-id": accountId },
});

if (error) {
  const p = parseProblem(error);
  console.error(p.title, p.detail, "request_id:", p.requestId);
} else {
  data.items.forEach((region) => console.log(region.name));
}
```

## License

[Apache-2.0](../../LICENSE). ComputeSphere is a trademark of ComputeSphere LLC.
