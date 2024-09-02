import {StrictMode} from "react";
import { createRoot } from 'react-dom/client';
import { HelloWorldResponse } from 'openapi_typescript/types'

// function that implements the HelloWorldResponse type from case3 as an example
function helloWorld(): HelloWorldResponse {
    return {
        hello: 'world'
    };
}

const container = document.getElementById('root');

const root = createRoot(container);

root.render(
    <StrictMode>
        <h1>Hello {helloWorld().hello}!</h1>
    </StrictMode>
);
