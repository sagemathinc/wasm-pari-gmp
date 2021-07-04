## Quickstart

Install the package

```sh
$ npm i @sagemath/pari-gmp
```

Then use it from node.js as follows:

```js
$ node
Welcome to Node.js v14.15.5.
> (async ()=>global.gp = await require('@sagemath/pari-gmp')())()
Promise { <pending> }
> gp('factor(2^128 + 1)')
'%1 = 5\n'
> gp('\\p100')
   realprecision = 105 significant digits (100 digits displayed)
'\n'
> gp('contfrac(Pi)')
'%4 = [3, 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2, 1, 84, 2, 1, 1, 15, 3, 13, 1, 4, 2, 6, 6, 99, 1, 2, 2, 6, 3, 5, 1, 1, 6, 8, 1, 7, 1, 2, 3, 7, 1, 2, 1, 1, 12, 1, 1, 1, 3, 1, 1, 8, 1, 1, 2, 1, 6, 1, 1, 5, 2, 2, 3, 1, 2, 4, 4, 16, 1, 161, 45, 1, 22, 1, 2, 2, 1, 4, 1, 2, 24, 1, 2, 1, 3, 1, 2, 1, 1, 10, 2, 5]\n'
```

Now square a large number, which should take a few seconds, as compared to Javascript's built in BigInt, which takes "**forever"** (?).  Pari without GMP is also reasonably fast, taking a second longer.

```js
> t=new Date();gp('n=10^(10^7)-17; m=n*n; 0'); new Date() - t  // intel server
2757
> t=new Date();gp('n=10^(10^7)-17; m=n*n; 0'); new Date() - t  // Apple M1
1573
> t=new Date(); n=BigInt(10)**BigInt(10**7)-BigInt(17); m=n*n; new Date()-t
... I gave up after a minute
```

## Build from source

You need to install [emscripten](https://emscripten.org/docs/getting_started/downloads.html). Then do

```
npm run build
```

This will download and build GMP, then download and build PARI linked against GMP for faster arithmetic.

## Problems/TODO

### Interrupting running code

Try `gp(factor(2^2001+1))` and hit control+c to try to interrupt the running computation. It terminates the Node.js interpreter as well, and there is no way to catch this.

### PARI packages

Some PARI commands require loading files from disk. E.g.,

```c
polgalois(x^8+1)
```

We just need to include the correct files in the right place by including an option like

```
--embed-file ../root/pari@/usr/local/share/pari/
```

in the OPT variable in `build-pari.sh`.

### Using with webpack5 in your browser

Make it easy to use this in frontend browser code bundled up using webpack.

## Acknowledgement

- Bill Allombert has been very helpful.
