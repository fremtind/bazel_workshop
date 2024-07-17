export const Greeting = ({name, className}: { name: string, className?: string }) => {
  return <h1 className={className}>Hello, {name}</h1>;
};
