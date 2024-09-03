import { HelloWorldResponse } from 'openapi_typescript/types'

// function that implements the HelloWorldResponse type from case3 as an example
function helloWorld(): HelloWorldResponse {
    return {
        hello: 'world'
    };
}

export const App = () => {
    return <h1>Hello {helloWorld().hello}!</h1>
}
