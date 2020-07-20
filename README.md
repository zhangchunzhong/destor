General Information
-------------------
Porting Destor form C (https://github.com/fomy/destor) to rust. 

Destor is a platform for data deduplication evaluation.

Features
--------
1. Container-based storage;
2. Chunk-level pipeline;
3. Fixed-sized chunking, Content-Defined Chunking (CDC) and an approximate file-level deduplication;
4. A variety of fingerprint indexes, including DDFS, Extreme Binning, Sparse Index, SiLo, etc.
5. A variety of rewriting algorithms, including CFL, CBR, CAP, HAR etc.
6. A variety of restore algorithms, including LRU, optimal replacement algorithm, rolling forward assembly.

Related papers
--------------
see doc/README.md

Environment
-----------
[Linux Mint 20](https://linuxmint.com/)

Build
-----
Follow the steps in page https://is.gd/c_rust

INSTALL
-------
```sh
#install openssl
sudo apt-get install -y libssl-dev
#install glib-2.0
sudo apt-get install -y libglib2.0-dev
#install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Running
-------
see doc/README.md

Configuration
-------------
see doc/README.md

Author
------
Julian Zhang
Email : zczxyz at 126.com 