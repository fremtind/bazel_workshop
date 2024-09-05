import {render, screen, waitFor} from "@testing-library/react";
import { App } from "./App";

describe('<App />', () => {
    it('should render correctly', async () => {
        render(<App />);

        await waitFor(() => {
            expect(screen.getByText(/Hello/)).toBeVisible();
        });
    });
})
