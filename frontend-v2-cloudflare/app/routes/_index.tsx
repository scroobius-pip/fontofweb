import * as Form from '@radix-ui/react-form';
import type { MetaFunction } from "@remix-run/node";
import { useSearchParams } from '@remix-run/react';
import { useEffect, useRef, useState } from 'react';

type FontWeights = string[]

type FontName = string
type FontSrc = { src: any; parentPath: string; }
type SrcMap = Map<FontName, FontSrc>
interface FontVariant {
  weight: string;
  lineHeight: string;
  size: string;
}

interface FontData {
  fallbacks: string[]
  fontName: string
  src: SrcObj;
  variants: Array<FontVariant>;
}

interface ElementFontData {
  [fontName: string]: FontData;
}

interface FontObj {
  [elementName: string]: ElementFontData
}


type SrcObj = {
  [type in SrcTypes]: string;
};


enum SrcTypes {
  eot = 'eot',
  ttf = 'ttf',
  otf = 'otf',
  woff2 = 'woff2',
  woff = 'woff',
  other = 'other'
}

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export default function Index() {
  const [searchParams] = useSearchParams();
  const url = searchParams.get('url');
  const iframeRef = useRef<HTMLIFrameElement>(null);

  // Update fontInfo state to be an object instead of an array
  const [fontInfo, setFontInfo] = useState<FontObj>({});

  useEffect(() => {
    // Define the event listener for receiving messages from the iframe
    const handleMessage = (event: MessageEvent) => {
      console.log(event)
      // Ensure the message comes from the expected iframe origin
      if (event.origin !== 'https://crawl.fontofweb.com') return;
      // Extract fontInfo from the received message
      const { fontInfo } = event.data;
      if (fontInfo && typeof fontInfo === 'object') {
        setFontInfo(fontInfo);
        console.log("Received font info:", fontInfo);
      }
    };

    // Add the event listener
    window.addEventListener('message', handleMessage);

    // Cleanup the event listener on component unmount
    return () => {
      window.removeEventListener('message', handleMessage);
    };
  }, []);

  return (
    <div className="flex h-screen w-full flex-col">
      <div>
        <Form.Root
          className='w-full bg-neutral-400'
          onSubmit={e => {

            const data = Object.fromEntries(new FormData(e.currentTarget));
            console.log(data);
          }}
        >
          <Form.Field name='url' className='flex flex-col gap-2'>
            <Form.Label>Website URL</Form.Label>
            <Form.Message match="valueMissing">
              Enter a URL
            </Form.Message>
            <Form.Control type='url' required className='px-4 py-2 bg-neutral-100' />
          </Form.Field>
          <Form.Submit className='p-4 bg-neutral-800 rounded-full px-8 text-neutral-50'>
            Submit
          </Form.Submit>
        </Form.Root>
      </div>

      {url && (
        <iframe
          ref={iframeRef}
          src={`https://crawl.fontofweb.com?url=${url}`}
        // className='hidden'
        />
      )}

      <div className="p-4">
        <h2>Font Info:</h2>
        <ul>
          {Object.entries(fontInfo).map(([elementName, fonts], elementIndex) => (
            <li key={elementIndex} className="mb-4">
              <h3 className="font-bold">{elementName}</h3>
              <ul className="ml-4 list-disc">
                {Object.entries(fonts).map(([fontName, fontData], fontIndex) => (
                  <li key={fontIndex} className="mb-2">
                    <h4 className="font-semibold">{fontName}</h4>
                    <ul className="ml-4 list-disc">
                      {fontData.variants.map((variant, variantIndex) => (
                        <li key={variantIndex}>
                          <p>Font Size: {variant.size}</p>
                          <p>Font Weight: {variant.weight}</p>
                          <p>Line Height: {variant.lineHeight}</p>
                          {
                            Object.entries(fontData.src).map(([fontSrcType, fontSrc]) => {
                              return <a href={decodeURI(fontSrc)} download >
                                {fontSrcType}
                              </a>
                            })
                          }
                        </li>
                      ))}
                    </ul>
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

const demoData = {
  "p": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "400"
        }
      ]
    }
  },
  "span": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "32px",
          "weight": "700"
        },
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "400"
        },
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "700"
        }
      ]
    },
    "Arial": {
      "fallbacks": [],
      "fontName": "Arial",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "13.3333px",
          "weight": "400"
        }
      ]
    }
  },
  "h1": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "32px",
          "weight": "700"
        },
        {
          "lineHeight": "1.2",
          "size": "24px",
          "weight": "700"
        }
      ]
    },
    "Arial": {
      "fallbacks": [],
      "fontName": "Arial",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "20px",
          "weight": "700"
        }
      ]
    }
  },
  "h2": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "24px",
          "weight": "700"
        }
      ]
    }
  },
  "h4": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "700"
        }
      ]
    }
  },
  "a": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "400"
        }
      ]
    }
  },
  "button": {
    "Arial": {
      "fallbacks": [],
      "fontName": "Arial",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "13.3333px",
          "weight": "400"
        }
      ]
    }
  },
  "body": {
    "Times": {
      "fallbacks": [],
      "fontName": "Times",
      "src": {},
      "variants": [
        {
          "lineHeight": "1.2",
          "size": "16px",
          "weight": "400"
        }
      ]
    }
  }
}