import { execFileSync } from "node:child_process";
import { existsSync } from "node:fs";
import { join } from "node:path";

export default (): void => {
  process.env.TZ = "UTC";

  const certificatePath = join(__dirname, "../db_config/test/server.crt");
  const keyPath = join(__dirname, "../db_config/test/server.key");
  if (existsSync(certificatePath) && existsSync(keyPath)) {
    return;
  }

  execFileSync(
    process.platform === "win32" ? "sh.exe" : "sh",
    ["scripts/generate-test-tls.sh"],
    {
      cwd: join(__dirname, ".."),
      stdio: "inherit",
    },
  );
};
