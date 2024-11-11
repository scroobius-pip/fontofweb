import * as Form from '@radix-ui/react-form';
import type { MetaFunction } from "@remix-run/node";
import { useSearchParams } from '@remix-run/react';
import { useEffect, useRef } from 'react';

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export default function Index() {
  const [searchParams] = useSearchParams()
  const url = searchParams.get('url')
  const iframeRef = useRef<any>()


  return (
    <div className="flex h-screen w-full  flex-col">
      <div>
        <Form.Root className='w-full bg-neutral-400' onSubmit={e => {
          const data = Object.fromEntries(new FormData(e.currentTarget))
          console.log(data)
        }}>
          <Form.Field name='url' className='flex flex-col gap-2' >
            <Form.Label className="">Website URL</Form.Label>
            <Form.Message className="" match="valueMissing">
              Enter a URL
            </Form.Message>
            <Form.Control type='url' required className='px-4 py-2 bg-neutral-100'>

            </Form.Control>

          </Form.Field>


          <Form.Submit className='p-4 bg-neutral-800 rounded-full px-8 text-neutral-50' >
            Submit
          </Form.Submit>
        </Form.Root>
      </div>
      {url && <iframe ref={iframeRef} src={`https://crawl.fontofweb.com?url=${url}`} className='h-2/3 w-full ' />}
    </div>
  );
}
