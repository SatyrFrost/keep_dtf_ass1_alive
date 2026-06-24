const { chromium } = require("playwright");
const path = require("path");

const SITE_URL = "https://dtfassign1.great-site.net/";
const FILE_PATH = path.join(__dirname, "keepalive.sql");

(async () => {
  const browser = await chromium.launch({
    headless: true
  });

  const page = await browser.newPage();

  try {
    console.log("Opening site...");
    await page.goto(SITE_URL, {
      waitUntil: "networkidle",
      timeout: 60000
    });

    console.log("Uploading SQL file...");

    await page.setInputFiles("#studentSqlFile", FILE_PATH);

    console.log("Clicking Upload & Grade Submission...");

    await page.getByRole("button", {
      name: /upload\s*&\s*grade submission/i
    }).click();

    console.log("Waiting for result...");

    await page.waitForTimeout(10000);

    const bodyText = await page.locator("body").innerText();

    console.log("========== PAGE RESULT START ==========");
    console.log(bodyText);
    console.log("========== PAGE RESULT END ==========");

    console.log("Keepalive completed.");
    
  } catch (error) {
    console.error("Keepalive failed:");
    console.error(error);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
})();
