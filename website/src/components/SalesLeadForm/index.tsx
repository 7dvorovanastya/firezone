import HubspotForm from "@/components/HubspotForm";

export default function SalesLeadForm() {
  return (
    <div className="py-8 px-4 mx-auto max-w-screen-xl lg:py-16 lg:px-6">
      <div className="mx-auto max-w-screen-md text-center">
        <h1 className="justify-center mb-8 md:mb-12 text-5xl font-extrabold tracking-tight text-neutral-900 sm:text-6xl ">
          Talk to a Firezone expert.
        </h1>
        <h2 className="mx-auto mb-8 max-w-2xl tracking-tight text-neutral-800 md:mb-12 text-xl">
          Ready to manage secure remote access for your organization? Learn how
          Firezone can help.
        </h2>
      </div>
      <div className="pt-8 grid sm:grid-cols-2 gap-4 items-top">
        <div className="mb-8">
          <h3 className="mb-4 lg:text-3xl md:text-2xl font-bold tracking-tight text-neutral-900 sm:text-xl ">
            Ensure business continuity
          </h3>
          <ul className="md:text-xl mb-8 list-inside list-disc">
            <li>Technical support with SLAs</li>
            <li>Private Slack channel</li>
            <li>White-glove onboarding</li>
          </ul>
          <h3 className="mb-4 lg:text-3xl md:text-2xl font-bold tracking-tight text-neutral-900 sm:text-xl ">
            Built for privacy and compliance
          </h3>
          <ul className="md:text-xl mb-8 list-inside list-disc">
            <li>Host on-prem in security sensitive environments</li>
            <li>Maintain full control of your data and network traffic</li>
          </ul>
          <h3 className="mb-4 lg:text-3xl md:text-2xl font-bold tracking-tight text-neutral-900 sm:text-xl ">
            Simplify management for admins
          </h3>
          <ul className="md:text-xl list-inside list-disc">
            <li>Automatic de-provisioning with SCIM</li>
            <li>Deployment advice for complex use cases</li>
          </ul>
        </div>
        <div className="w-full">
          <HubspotForm
            title="Contact sales"
            portalId="23723443"
            formId="76637b95-cef7-4b94-8e7a-411aeec5fbb1"
          />
        </div>
      </div>
    </div>
  );
}
