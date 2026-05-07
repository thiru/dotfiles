/**
 * Displays the current System Prompt.
 *
 * Use /system to view the full system prompt in a pager.
 */
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("system", {
    description: "Show the full system prompt:",
    handler: async (_args, ctx) => {
      const prompt = ctx.getSystemPrompt();
      ctx.ui.notify('The current System Prompt follows', 'warning');
      ctx.ui.notify(prompt, 'info');
    },
  });
}
