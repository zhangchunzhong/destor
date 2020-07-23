#ifndef AE_CHUNKING_H_
#define AE_CHUNKING_H_

extern  void __ae_init(int min, int max, int avg);
extern  int  __ae_chunk_data(unsigned char *p, int n);

#endif
