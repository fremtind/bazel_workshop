#!/usr/bin/env node

// This is used to create JSON matrices for the changed targets, to be consumed by strategies in GitHub Actions workflows.

const readline = require('readline');

const getStdIn = () => {
    return new Promise((resolve, reject) => {
        const lines = [];
        const rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            terminal: false,
        });

        rl.on('line', (line) => {
            lines.push(line);
        });

        rl.once('close', () => {
            resolve(lines);
        });
    });
};

const main = async (args) => {
    const prefix = args.shift();
    const matrix = [];
    const packageNames = new Set();

    const lines = await getStdIn();

    for (const line of lines) {
        const [packageName] = line.split(':');
        packageNames.add(packageName.replace('//', ''));
    }
    for (const packageName of packageNames) {
        const packageParts = packageName.split('/');
        const teamName = packageParts[1].replace('team-', ''); // teams/team-1/...
        let teamShortname = teamName.slice(0, 7); // in case of long team names (pick your preferred length), truncate to make it easier to read in CI workflows
        if (teamShortname !== teamName) {
            teamShortname += '..';
        }
        matrix.push({
            package: packageName,
            team: teamName,
            team_shortname: teamShortname,
            name: packageParts[packageParts.length - 1],
        });
    }

    process.stdout.write(JSON.stringify({ [prefix]: matrix }));
};

main(process.argv.slice(2));
