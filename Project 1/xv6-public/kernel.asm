
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 64 11 80       	mov    $0x801164d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 76 10 80       	push   $0x80107620
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 45 44 00 00       	call   801044a0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 76 10 80       	push   $0x80107627
80100097:	50                   	push   %eax
80100098:	e8 d3 42 00 00       	call   80104370 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 87 45 00 00       	call   80104670 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 a9 44 00 00       	call   80104610 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 42 00 00       	call   801043b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 76 10 80       	push   $0x8010762e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 8d 42 00 00       	call   80104450 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 76 10 80       	push   $0x8010763f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 42 00 00       	call   80104450 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 41 00 00       	call   80104410 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 44 00 00       	call   80104670 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 9f 43 00 00       	jmp    80104610 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 76 10 80       	push   $0x80107646
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 cb 43 00 00       	call   80104670 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 7e 3d 00 00       	call   80104050 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 15 43 00 00       	call   80104610 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 bf 42 00 00       	call   80104610 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 76 10 80       	push   $0x8010764d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 84 7e 10 80 	movl   $0x80107e84,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 f3 40 00 00       	call   801044c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 76 10 80       	push   $0x80107661
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 5d 00 00       	call   80106130 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 5c 00 00       	call   80106130 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 5c 00 00       	call   80106130 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 5c 00 00       	call   80106130 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 7a 42 00 00       	call   801047d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 c5 41 00 00       	call   80104730 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 76 10 80       	push   $0x80107665
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 c0 40 00 00       	call   80104670 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 27 40 00 00       	call   80104610 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 90 76 10 80 	movzbl -0x7fef8970(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 83 3e 00 00       	call   80104670 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 76 10 80       	mov    $0x80107678,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 b0 3d 00 00       	call   80104610 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 76 10 80       	push   $0x8010767f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 d8 3d 00 00       	call   80104670 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 3b 3c 00 00       	call   80104610 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 dd 37 00 00       	jmp    801041f0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 c7 36 00 00       	call   80104110 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 76 10 80       	push   $0x80107688
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 2b 3a 00 00       	call   801044a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 cc 22 00 00       	call   80102de0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 87 67 00 00       	call   801072c0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 38 65 00 00       	call   801070e0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 12 64 00 00       	call   80106ff0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 20 66 00 00       	call   80107240 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 8a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 79 64 00 00       	call   801070e0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 d8 66 00 00       	call   80107360 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 58 3c 00 00       	call   80104930 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 44 3c 00 00       	call   80104930 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 33 68 00 00       	call   80107530 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 65 00 00       	call   80107240 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 c8 67 00 00       	call   80107530 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 4a 3b 00 00       	call   801048f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 8e 60 00 00       	call   80106e60 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 64 00 00       	call   80107240 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 f7 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 76 10 80       	push   $0x801076a1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 ad 76 10 80       	push   $0x801076ad
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 7b 36 00 00       	call   801044a0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 2a 38 00 00       	call   80104670 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 9a 37 00 00       	call   80104610 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 81 37 00 00       	call   80104610 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 bc 37 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 3f 37 00 00       	call   80104610 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 76 10 80       	push   $0x801076b4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 6a 37 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 cf 36 00 00       	call   80104610 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 9d 36 00 00       	jmp    80104610 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 f3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 49 1e 00 00       	jmp    80102de0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 92 25 00 00       	call   80103540 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 bc 76 10 80       	push   $0x801076bc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 4e 26 00 00       	jmp    801036e0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 c6 76 10 80       	push   $0x801076c6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 d2 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 3d 1c 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 76 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 cf 76 10 80       	push   $0x801076cf
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 32 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 d5 76 10 80       	push   $0x801076d5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 3e 1d 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 df 76 10 80       	push   $0x801076df
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 76 10 80       	push   $0x801076f2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 4e 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 06 34 00 00       	call   80104730 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 1e 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 01 33 00 00       	call   80104670 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 34 32 00 00       	call   80104610 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 06 32 00 00       	call   80104610 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 08 77 10 80       	push   $0x80107708
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 86 1a 00 00       	call   80102f50 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 18 77 10 80       	push   $0x80107718
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 8a 32 00 00       	call   801047d0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 77 10 80       	push   $0x8010772b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 25 2f 00 00       	call   801044a0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 77 10 80       	push   $0x80107732
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 dc 2d 00 00       	call   80104370 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 0f 32 00 00       	call   801047d0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 98 77 10 80       	push   $0x80107798
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 9d 30 00 00       	call   80104730 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 ab 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 38 77 10 80       	push   $0x80107738
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 9a 30 00 00       	call   801047d0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 12 18 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 0c 2f 00 00       	call   80104670 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 9c 2e 00 00       	call   80104610 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 09 2c 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 b3 2f 00 00       	call   801047d0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 50 77 10 80       	push   $0x80107750
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 77 10 80       	push   $0x8010774a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 d8 2b 00 00       	call   80104450 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 7c 2b 00 00       	jmp    80104410 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 77 10 80       	push   $0x8010775f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 eb 2a 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 31 2b 00 00       	call   80104410 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 85 2d 00 00       	call   80104670 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 0b 2d 00 00       	jmp    80104610 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 5b 2d 00 00       	call   80104670 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 ec 2c 00 00       	call   80104610 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 28 2a 00 00       	call   80104450 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 d1 29 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 5f 77 10 80       	push   $0x8010775f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 94 2c 00 00       	call   801047d0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 98 2b 00 00       	call   801047d0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 10 13 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 6d 2b 00 00       	call   80104840 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 0e 2b 00 00       	call   80104840 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 79 77 10 80       	push   $0x80107779
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 77 10 80       	push   $0x80107767
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 d1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 b1 28 00 00       	call   80104670 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 41 28 00 00       	call   80104610 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 a4 29 00 00       	call   801047d0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 bf 25 00 00       	call   80104450 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 5d 25 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 f0 28 00 00       	call   801047d0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 20 25 00 00       	call   80104450 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 c1 24 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 de 24 00 00       	call   80104450 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 bb 24 00 00       	call   80104450 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 64 24 00 00       	call   80104410 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 5f 77 10 80       	push   $0x8010775f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 4e 28 00 00       	call   80104890 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 88 77 10 80       	push   $0x80107788
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 ca 7d 10 80       	push   $0x80107dca
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 f4 77 10 80       	push   $0x801077f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 77 10 80       	push   $0x801077eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 78 10 80       	push   $0x80107806
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 cb 22 00 00       	call   801044a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 1d 24 00 00       	call   80104670 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 5e 1e 00 00       	call   80104110 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 40 23 00 00       	call   80104610 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 5d 21 00 00       	call   80104450 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 43 23 00 00       	call   80104670 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 e2 1c 00 00       	call   80104050 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 85 22 00 00       	jmp    80104610 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 35 78 10 80       	push   $0x80107835
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 78 10 80       	push   $0x80107820
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 78 10 80       	push   $0x8010780a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 54 78 10 80       	push   $0x80107854
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024c0 <halt>:

// Halt function to stop the system
void halt(void)
{
    // Use assembly to halt the system and stop QEMU
    asm volatile("cli");  // Clear interrupts
801024c0:	fa                   	cli    
    asm volatile("hlt");  // Halt the CPU
801024c1:	f4                   	hlt    
}
801024c2:	c3                   	ret    
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb d0 64 11 80    	cmp    $0x801164d0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 29 22 00 00       	call   80104730 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 26 11 80       	mov    0x80112678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave  
8010252e:	c3                   	ret    
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 26 11 80       	push   $0x80112640
80102538:	e8 33 21 00 00       	call   80104670 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave  
    release(&kmem.lock);
80102553:	e9 b8 20 00 00       	jmp    80104610 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 86 78 10 80       	push   $0x80107886
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102574:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102577:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret    
80102615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 8c 78 10 80       	push   $0x8010788c
80102630:	68 40 26 11 80       	push   $0x80112640
80102635:	e8 66 1e 00 00       	call   801044a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102690:	a1 74 26 11 80       	mov    0x80112674,%eax
80102695:	85 c0                	test   %eax,%eax
80102697:	75 1f                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102699:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010269e:	85 c0                	test   %eax,%eax
801026a0:	74 0e                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a2:	8b 10                	mov    (%eax),%edx
801026a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026aa:	c3                   	ret    
801026ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 26 11 80       	push   $0x80112640
801026c3:	e8 a8 1f 00 00       	call   80104670 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 26 11 80       	push   $0x80112640
801026f1:	e8 1a 1f 00 00       	call   80104610 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102700:	ba 64 00 00 00       	mov    $0x64,%edx
80102705:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102706:	a8 01                	test   $0x1,%al
80102708:	0f 84 c2 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
8010270e:	55                   	push   %ebp
8010270f:	ba 60 00 00 00       	mov    $0x60,%edx
80102714:	89 e5                	mov    %esp,%ebp
80102716:	53                   	push   %ebx
80102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102718:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010271e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102721:	3c e0                	cmp    $0xe0,%al
80102723:	74 5b                	je     80102780 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102725:	89 da                	mov    %ebx,%edx
80102727:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010272a:	84 c0                	test   %al,%al
8010272c:	78 62                	js     80102790 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010272e:	85 d2                	test   %edx,%edx
80102730:	74 09                	je     8010273b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102732:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102735:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102738:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010273b:	0f b6 91 c0 79 10 80 	movzbl -0x7fef8640(%ecx),%edx
  shift ^= togglecode[data];
80102742:	0f b6 81 c0 78 10 80 	movzbl -0x7fef8740(%ecx),%eax
  shift |= shiftcode[data];
80102749:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010274b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010274f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102755:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102758:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275b:	8b 04 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%eax
80102762:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102766:	74 0b                	je     80102773 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102768:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276b:	83 fa 19             	cmp    $0x19,%edx
8010276e:	77 48                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102770:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102776:	c9                   	leave  
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010278b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 d2                	test   %edx,%edx
80102795:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102798:	0f b6 81 c0 79 10 80 	movzbl -0x7fef8640(%ecx),%eax
8010279f:	83 c8 40             	or     $0x40,%eax
801027a2:	0f b6 c0             	movzbl %al,%eax
801027a5:	f7 d0                	not    %eax
801027a7:	21 d8                	and    %ebx,%eax
}
801027a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ac:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027b1:	31 c0                	xor    %eax,%eax
}
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    
801027b5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c1:	c9                   	leave  
      c += 'a' - 'A';
801027c2:	83 f9 1a             	cmp    $0x1a,%ecx
801027c5:	0f 42 c2             	cmovb  %edx,%eax
}
801027c8:	c3                   	ret    
801027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027e6:	68 00 27 10 80       	push   $0x80102700
801027eb:	e8 90 e0 ff ff       	call   80100880 <consoleintr>
}
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102800:	a1 80 26 11 80       	mov    0x80112680,%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	0f 84 cb 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
8010280d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102814:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010282e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102848:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102855:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285b:	8b 50 30             	mov    0x30(%eax),%edx
8010285e:	c1 ea 10             	shr    $0x10,%edx
80102861:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102867:	75 77                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
80102869:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102870:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102876:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
801028b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 77 ff ff ff       	jmp    80102869 <lapicinit+0x69>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret    
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret    
80102913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 26 11 80       	mov    0x80112680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 da                	mov    %ebx,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 da                	mov    %ebx,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c7                	mov    %eax,%edi
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 da                	mov    %ebx,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	89 c6                	mov    %eax,%esi
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a67:	84 c0                	test   %al,%al
80102a69:	78 9d                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a6f:	89 fa                	mov    %edi,%edx
80102a71:	0f b6 fa             	movzbl %dl,%edi
80102a74:	89 f2                	mov    %esi,%edx
80102a76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a7d:	0f b6 f2             	movzbl %dl,%esi
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 da                	mov    %ebx,%edx
80102a82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a99:	31 c0                	xor    %eax,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
80102ab0:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 da                	mov    %ebx,%edx
80102ab5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 da                	mov    %ebx,%edx
80102ac6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac9:	b8 07 00 00 00       	mov    $0x7,%eax
80102ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
80102ad2:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 da                	mov    %ebx,%edx
80102ad7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 da                	mov    %ebx,%edx
80102ae8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aeb:	b8 09 00 00 00       	mov    $0x9,%eax
80102af0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af1:	89 ca                	mov    %ecx,%edx
80102af3:	ec                   	in     (%dx),%al
80102af4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102afd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b00:	6a 18                	push   $0x18
80102b02:	50                   	push   %eax
80102b03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b06:	50                   	push   %eax
80102b07:	e8 74 1c 00 00       	call   80104780 <memcmp>
80102b0c:	83 c4 10             	add    $0x10,%esp
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	0f 85 f1 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b1b:	75 78                	jne    80102b95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b95:	8b 75 08             	mov    0x8(%ebp),%esi
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 06                	mov    %eax,(%esi)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 46 04             	mov    %eax,0x4(%esi)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 46 08             	mov    %eax,0x8(%esi)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 46 0c             	mov    %eax,0xc(%esi)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 46 10             	mov    %eax,0x10(%esi)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 26 11 80    	push   0x801126e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c14:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 97 1b 00 00       	call   801047d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret    
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret    
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 26 11 80    	push   0x801126d4
80102c7d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave  
80102cca:	c3                   	ret    
80102ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ccf:	90                   	nop

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 c0 7a 10 80       	push   $0x80107ac0
80102cdf:	68 a0 26 11 80       	push   $0x801126a0
80102ce4:	e8 b7 17 00 00       	call   801044a0 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 2b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d07:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave  
80102d66:	c3                   	ret    
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 26 11 80       	push   $0x801126a0
80102d7b:	e8 f0 18 00 00       	call   80104670 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 26 11 80       	push   $0x801126a0
80102d90:	68 a0 26 11 80       	push   $0x801126a0
80102d95:	e8 b6 12 00 00       	call   80104050 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dc7:	68 a0 26 11 80       	push   $0x801126a0
80102dcc:	e8 3f 18 00 00       	call   80104610 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 26 11 80       	push   $0x801126a0
80102dee:	e8 7d 18 00 00       	call   80104670 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 26 11 80       	push   $0x801126a0
80102e2c:	e8 df 17 00 00       	call   80104610 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 26 11 80       	push   $0x801126a0
80102e46:	e8 25 18 00 00       	call   80104670 <acquire>
    wakeup(&log);
80102e4b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e52:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e59:	00 00 00 
    wakeup(&log);
80102e5c:	e8 af 12 00 00       	call   80104110 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e68:	e8 a3 17 00 00       	call   80104610 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret    
80102e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ea4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 07 19 00 00       	call   801047d0 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 26 11 80       	push   $0x801126a0
80102f18:	e8 f3 11 00 00       	call   80104110 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f24:	e8 e7 16 00 00       	call   80104610 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 c4 7a 10 80       	push   $0x80107ac4
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4f:	90                   	nop

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	0f 8f 85 00 00 00    	jg     80102fee <log_write+0x9e>
80102f69:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f6e:	83 e8 01             	sub    $0x1,%eax
80102f71:	39 c2                	cmp    %eax,%edx
80102f73:	7d 79                	jge    80102fee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f75:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f7a:	85 c0                	test   %eax,%eax
80102f7c:	7e 7d                	jle    80102ffb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 a0 26 11 80       	push   $0x801126a0
80102f86:	e8 e5 16 00 00       	call   80104670 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	85 d2                	test   %edx,%edx
80102f96:	7e 4a                	jle    80102fe2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f98:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f9b:	31 c0                	xor    %eax,%eax
80102f9d:	eb 08                	jmp    80102fa7 <log_write+0x57>
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 46 16 00 00       	jmp    80104610 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x67>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x87>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 d3 7a 10 80       	push   $0x80107ad3
80102ff6:	e8 85 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 e9 7a 10 80       	push   $0x80107ae9
80103003:	e8 78 d3 ff ff       	call   80100380 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 44 09 00 00       	call   80103960 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 3d 09 00 00       	call   80103960 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 04 7b 10 80       	push   $0x80107b04
8010302d:	e8 6e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 29 2d 00 00       	call   80105d60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 c4 08 00 00       	call   80103900 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 f1 0b 00 00       	call   80103c40 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103056:	e8 f5 3d 00 00       	call   80106e50 <switchkvm>
  seginit();
8010305b:	e8 60 3d 00 00       	call   80106dc0 <seginit>
  lapicinit();
80103060:	e8 9b f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103065:	e8 a6 ff ff ff       	call   80103010 <mpmain>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103074:	83 e4 f0             	and    $0xfffffff0,%esp
80103077:	ff 71 fc             	push   -0x4(%ecx)
8010307a:	55                   	push   %ebp
8010307b:	89 e5                	mov    %esp,%ebp
8010307d:	53                   	push   %ebx
8010307e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010307f:	83 ec 08             	sub    $0x8,%esp
80103082:	68 00 00 40 80       	push   $0x80400000
80103087:	68 d0 64 11 80       	push   $0x801164d0
8010308c:	e8 8f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103091:	e8 aa 42 00 00       	call   80107340 <kvmalloc>
  mpinit();        // detect other processors
80103096:	e8 85 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309b:	e8 60 f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030a0:	e8 1b 3d 00 00       	call   80106dc0 <seginit>
  picinit();       // disable pic
801030a5:	e8 76 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030aa:	e8 21 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801030af:	e8 ac d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030b4:	e8 97 2f 00 00       	call   80106050 <uartinit>
  pinit();         // process table
801030b9:	e8 22 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
801030be:	e8 1d 2c 00 00       	call   80105ce0 <tvinit>
  binit();         // buffer cache
801030c3:	e8 78 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030c8:	e8 43 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030cd:	e8 ee f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d2:	83 c4 0c             	add    $0xc,%esp
801030d5:	68 8a 00 00 00       	push   $0x8a
801030da:	68 8c b4 10 80       	push   $0x8010b48c
801030df:	68 00 70 00 80       	push   $0x80007000
801030e4:	e8 e7 16 00 00       	call   801047d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030f3:	00 00 00 
801030f6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030fb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103100:	76 7e                	jbe    80103180 <main+0x110>
80103102:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103107:	eb 20                	jmp    80103129 <main+0xb9>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103110:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 d2 07 00 00       	call   80103900 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 59 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010314b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ea f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 2e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103192:	e8 19 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 18 7b 10 80       	push   $0x80107b18
801031d3:	56                   	push   %esi
801031d4:	e8 a7 15 00 00       	call   80104780 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 1d 7b 10 80       	push   $0x80107b1d
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 ec 14 00 00       	call   80104780 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 22 7b 10 80       	push   $0x80107b22
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 18 7b 10 80       	push   $0x80107b18
801033d7:	53                   	push   %ebx
801033d8:	e8 a3 13 00 00       	call   80104780 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 3c 7b 10 80       	push   $0x80107b3c
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 d0 d9 ff ff       	call   80100e30 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 c1 d9 ff ff       	call   80100e30 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 5b 7b 10 80       	push   $0x80107b5b
801034b8:	50                   	push   %eax
801034b9:	e8 e2 0f 00 00       	call   801044a0 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 e1 d9 ff ff       	call   80100ef0 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 cf d9 ff ff       	call   80100ef0 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 1c 11 00 00       	call   80104670 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 9c 0b 00 00       	call   80104110 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 77 10 00 00       	jmp    80104610 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 67 10 00 00       	call   80104610 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 16 ef ff ff       	jmp    801024d0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 37 0b 00 00       	call   80104110 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 7e 10 00 00       	call   80104670 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 43 03 00 00       	call   80103980 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 c3 0a 00 00       	call   80104110 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 fa 09 00 00       	call   80104050 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 8f 0f 00 00       	call   80104610 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 41 0a 00 00       	call   80104110 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 39 0f 00 00       	call   80104610 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 75 0f 00 00       	call   80104670 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 6b 02 00 00       	call   80103980 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 26 09 00 00       	call   80104050 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 85 09 00 00       	call   80104110 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 7d 0e 00 00       	call   80104610 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 62 0e 00 00       	call   80104610 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 20 2d 11 80       	push   $0x80112d20
801037d1:	e8 9a 0e 00 00       	call   80104670 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 10                	jmp    801037eb <allocproc+0x2b>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	83 c3 7c             	add    $0x7c,%ebx
801037e3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801037e9:	74 75                	je     80103860 <allocproc+0xa0>
    if(p->state == UNUSED)
801037eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ee:	85 c0                	test   %eax,%eax
801037f0:	75 ee                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103801:	89 43 10             	mov    %eax,0x10(%ebx)
80103804:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103807:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010380c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103812:	e8 f9 0d 00 00       	call   80104610 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103817:	e8 74 ee ff ff       	call   80102690 <kalloc>
8010381c:	83 c4 10             	add    $0x10,%esp
8010381f:	89 43 08             	mov    %eax,0x8(%ebx)
80103822:	85 c0                	test   %eax,%eax
80103824:	74 53                	je     80103879 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103826:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010382c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103834:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103837:	c7 40 14 cc 5c 10 80 	movl   $0x80105ccc,0x14(%eax)
  p->context = (struct context*)sp;
8010383e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103841:	6a 14                	push   $0x14
80103843:	6a 00                	push   $0x0
80103845:	50                   	push   %eax
80103846:	e8 e5 0e 00 00       	call   80104730 <memset>
  p->context->eip = (uint)forkret;
8010384b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010384e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103851:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
80103858:	89 d8                	mov    %ebx,%eax
8010385a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385d:	c9                   	leave  
8010385e:	c3                   	ret    
8010385f:	90                   	nop
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 2d 11 80       	push   $0x80112d20
8010386a:	e8 a1 0d 00 00       	call   80104610 <release>
}
8010386f:	89 d8                	mov    %ebx,%eax
  return 0;
80103871:	83 c4 10             	add    $0x10,%esp
}
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103880:	31 db                	xor    %ebx,%ebx
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 2d 11 80       	push   $0x80112d20
8010389b:	e8 70 0d 00 00       	call   80104610 <release>

  if (first) {
801038a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave  
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 9c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 00 f4 ff ff       	call   80102cd0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 60 7b 10 80       	push   $0x80107b60
801038eb:	68 20 2d 11 80       	push   $0x80112d20
801038f0:	e8 ab 0b 00 00       	call   801044a0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf  
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 ef ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret    
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 67 7b 10 80       	push   $0x80107b67
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 a4 7c 10 80       	push   $0x80107ca4
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave  
  return mycpu()-cpus;
8010396c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 94 0b 00 00       	call   80104520 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 d4 0b 00 00       	call   80104570 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave  
801039a2:	c3                   	ret    
801039a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 04 fe ff ff       	call   801037c0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 f8 38 00 00       	call   801072c0 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 b4 10 80       	push   $0x8010b460
801039e0:	50                   	push   %eax
801039e1:	e8 8a 35 00 00       	call   80106f70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 35 0d 00 00       	call   80104730 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 90 7b 10 80       	push   $0x80107b90
80103a54:	50                   	push   %eax
80103a55:	e8 96 0e 00 00       	call   801048f0 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 99 7b 10 80 	movl   $0x80107b99,(%esp)
80103a61:	e8 3a e6 ff ff       	call   801020a0 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a70:	e8 fb 0b 00 00       	call   80104670 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a83:	e8 88 0b 00 00       	call   80104610 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 77 7b 10 80       	push   $0x80107b77
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 73 0a 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 b3 0a 00 00       	call   80104570 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 90 33 00 00       	call   80106e60 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret    
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 f1 35 00 00       	call   801070e0 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 01 37 00 00       	call   80107210 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 f2 09 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 32 0a 00 00       	call   80104570 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 7d fc ff ff       	call   801037c0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 b7 00 00 00    	je     80103c05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 53 38 00 00       	call   801073b0 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 a1 00 00 00    	je     80103c0c <fork+0xec>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 ff d2 ff ff       	call   80100ea0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 8f db ff ff       	call   80101750 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 1a 0d 00 00       	call   801048f0 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be0:	e8 8b 0a 00 00       	call   80104670 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf3:	e8 18 0a 00 00       	call   80104610 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
    return -1;
80103c05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c0a:	eb ef                	jmp    80103bfb <fork+0xdb>
    kfree(np->kstack);
80103c0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	ff 73 08             	push   0x8(%ebx)
80103c15:	e8 b6 e8 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103c1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c30:	eb c9                	jmp    80103bfb <fork+0xdb>
80103c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 b2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c55:	00 00 00 
  struct cpu *c = mycpu();
80103c58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c5a:	8d 78 04             	lea    0x4(%eax),%edi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti    
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c69:	68 20 2d 11 80       	push   $0x80112d20
80103c6e:	e8 fd 09 00 00       	call   80104670 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 cb 31 00 00       	call   80106e60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	push   0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 a4 0c 00 00       	call   8010494b <swtch>
      switchkvm();
80103ca7:	e8 a4 31 00 00       	call   80106e50 <switchkvm>
      c->proc = 0;
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	83 c3 7c             	add    $0x7c,%ebx
80103cbc:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cc2:	75 bc                	jne    80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 20 2d 11 80       	push   $0x80112d20
80103ccc:	e8 3f 09 00 00       	call   80104610 <release>
    sti();
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	eb 8a                	jmp    80103c60 <scheduler+0x20>
80103cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 36 08 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103cea:	e8 11 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 76 08 00 00       	call   80104570 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 20 2d 11 80       	push   $0x80112d20
80103d02:	e8 c9 08 00 00       	call   801045d0 <holding>
80103d07:	83 c4 10             	add    $0x10,%esp
80103d0a:	85 c0                	test   %eax,%eax
80103d0c:	74 4f                	je     80103d5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d0e:	e8 ed fb ff ff       	call   80103900 <mycpu>
80103d13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1a:	75 68                	jne    80103d84 <sched+0xa4>
  if(p->state == RUNNING)
80103d1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d20:	74 55                	je     80103d77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d22:	9c                   	pushf  
80103d23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d24:	f6 c4 02             	test   $0x2,%ah
80103d27:	75 41                	jne    80103d6a <sched+0x8a>
  intena = mycpu()->intena;
80103d29:	e8 d2 fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d37:	e8 c4 fb ff ff       	call   80103900 <mycpu>
80103d3c:	83 ec 08             	sub    $0x8,%esp
80103d3f:	ff 70 04             	push   0x4(%eax)
80103d42:	53                   	push   %ebx
80103d43:	e8 03 0c 00 00       	call   8010494b <swtch>
  mycpu()->intena = intena;
80103d48:	e8 b3 fb ff ff       	call   80103900 <mycpu>
}
80103d4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret    
    panic("sched ptable.lock");
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	68 9b 7b 10 80       	push   $0x80107b9b
80103d65:	e8 16 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 c7 7b 10 80       	push   $0x80107bc7
80103d72:	e8 09 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 b9 7b 10 80       	push   $0x80107bb9
80103d7f:	e8 fc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 ad 7b 10 80       	push   $0x80107bad
80103d8c:	e8 ef c5 ff ff       	call   80100380 <panic>
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103da9:	e8 d2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103dae:	39 05 54 4c 11 80    	cmp    %eax,0x80114c54
80103db4:	0f 84 fd 00 00 00    	je     80103eb7 <exit+0x117>
80103dba:	89 c3                	mov    %eax,%ebx
80103dbc:	8d 70 28             	lea    0x28(%eax),%esi
80103dbf:	8d 78 68             	lea    0x68(%eax),%edi
80103dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dc8:	8b 06                	mov    (%esi),%eax
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 12                	je     80103de0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	50                   	push   %eax
80103dd2:	e8 19 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103dd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ddd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103de0:	83 c6 04             	add    $0x4,%esi
80103de3:	39 f7                	cmp    %esi,%edi
80103de5:	75 e1                	jne    80103dc8 <exit+0x28>
  begin_op();
80103de7:	e8 84 ef ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);  // Clean up the current working directory
80103dec:	83 ec 0c             	sub    $0xc,%esp
80103def:	ff 73 68             	push   0x68(%ebx)
80103df2:	e8 b9 da ff ff       	call   801018b0 <iput>
  end_op();
80103df7:	e8 e4 ef ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
80103dfc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e03:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e0a:	e8 61 08 00 00       	call   80104670 <acquire>
  wakeup1(curproc->parent);
80103e0f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e15:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e1a:	eb 0e                	jmp    80103e2a <exit+0x8a>
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e20:	83 c0 7c             	add    $0x7c,%eax
80103e23:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e28:	74 1c                	je     80103e46 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0x80>
80103e30:	3b 50 20             	cmp    0x20(%eax),%edx
80103e33:	75 eb                	jne    80103e20 <exit+0x80>
      p->state = RUNNABLE;
80103e35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	83 c0 7c             	add    $0x7c,%eax
80103e3f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e44:	75 e4                	jne    80103e2a <exit+0x8a>
      p->parent = initproc;
80103e46:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e51:	eb 10                	jmp    80103e63 <exit+0xc3>
80103e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e57:	90                   	nop
80103e58:	83 c2 7c             	add    $0x7c,%edx
80103e5b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e61:	74 3b                	je     80103e9e <exit+0xfe>
    if(p->parent == curproc){
80103e63:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e66:	75 f0                	jne    80103e58 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e68:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e6c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e6f:	75 e7                	jne    80103e58 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e71:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e76:	eb 12                	jmp    80103e8a <exit+0xea>
80103e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop
80103e80:	83 c0 7c             	add    $0x7c,%eax
80103e83:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e88:	74 ce                	je     80103e58 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0xe0>
80103e90:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e93:	75 eb                	jne    80103e80 <exit+0xe0>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e9c:	eb e2                	jmp    80103e80 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e9e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ea5:	e8 36 fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 e8 7b 10 80       	push   $0x80107be8
80103eb2:	e8 c9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 db 7b 10 80       	push   $0x80107bdb
80103ebf:	e8 bc c4 ff ff       	call   80100380 <panic>
80103ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop

80103ed0 <wait>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	56                   	push   %esi
80103ed4:	53                   	push   %ebx
  pushcli();
80103ed5:	e8 46 06 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103eda:	e8 21 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103edf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ee5:	e8 86 06 00 00       	call   80104570 <popcli>
  acquire(&ptable.lock);
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 20 2d 11 80       	push   $0x80112d20
80103ef2:	e8 79 07 00 00       	call   80104670 <acquire>
80103ef7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103efa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f01:	eb 10                	jmp    80103f13 <wait+0x43>
80103f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f07:	90                   	nop
80103f08:	83 c3 7c             	add    $0x7c,%ebx
80103f0b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f11:	74 1b                	je     80103f2e <wait+0x5e>
      if(p->parent != curproc)
80103f13:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f16:	75 f0                	jne    80103f08 <wait+0x38>
      if(p->state == ZOMBIE){
80103f18:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f1c:	74 62                	je     80103f80 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f21:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f26:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f2c:	75 e5                	jne    80103f13 <wait+0x43>
    if(!havekids || curproc->killed){
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	0f 84 a0 00 00 00    	je     80103fd6 <wait+0x106>
80103f36:	8b 46 24             	mov    0x24(%esi),%eax
80103f39:	85 c0                	test   %eax,%eax
80103f3b:	0f 85 95 00 00 00    	jne    80103fd6 <wait+0x106>
  pushcli();
80103f41:	e8 da 05 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103f46:	e8 b5 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f51:	e8 1a 06 00 00       	call   80104570 <popcli>
  if(p == 0)
80103f56:	85 db                	test   %ebx,%ebx
80103f58:	0f 84 8f 00 00 00    	je     80103fed <wait+0x11d>
  p->chan = chan;
80103f5e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f68:	e8 73 fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103f6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f74:	eb 84                	jmp    80103efa <wait+0x2a>
80103f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f80:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f83:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f86:	ff 73 08             	push   0x8(%ebx)
80103f89:	e8 42 e5 ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
80103f8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f95:	5a                   	pop    %edx
80103f96:	ff 73 04             	push   0x4(%ebx)
80103f99:	e8 a2 32 00 00       	call   80107240 <freevm>
        p->pid = 0;
80103f9e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fa5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fb0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fbe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fc5:	e8 46 06 00 00       	call   80104610 <release>
        return pid;
80103fca:	83 c4 10             	add    $0x10,%esp
}
80103fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd0:	89 f0                	mov    %esi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret    
      release(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fde:	68 20 2d 11 80       	push   $0x80112d20
80103fe3:	e8 28 06 00 00       	call   80104610 <release>
      return -1;
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	eb e0                	jmp    80103fcd <wait+0xfd>
    panic("sleep");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 f4 7b 10 80       	push   $0x80107bf4
80103ff5:	e8 86 c3 ff ff       	call   80100380 <panic>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <yield>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104007:	68 20 2d 11 80       	push   $0x80112d20
8010400c:	e8 5f 06 00 00       	call   80104670 <acquire>
  pushcli();
80104011:	e8 0a 05 00 00       	call   80104520 <pushcli>
  c = mycpu();
80104016:	e8 e5 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010401b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104021:	e8 4a 05 00 00       	call   80104570 <popcli>
  myproc()->state = RUNNABLE;
80104026:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010402d:	e8 ae fc ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80104032:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104039:	e8 d2 05 00 00       	call   80104610 <release>
}
8010403e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	c9                   	leave  
80104045:	c3                   	ret    
80104046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404d:	8d 76 00             	lea    0x0(%esi),%esi

80104050 <sleep>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	8b 7d 08             	mov    0x8(%ebp),%edi
8010405c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010405f:	e8 bc 04 00 00       	call   80104520 <pushcli>
  c = mycpu();
80104064:	e8 97 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104069:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010406f:	e8 fc 04 00 00       	call   80104570 <popcli>
  if(p == 0)
80104074:	85 db                	test   %ebx,%ebx
80104076:	0f 84 87 00 00 00    	je     80104103 <sleep+0xb3>
  if(lk == 0)
8010407c:	85 f6                	test   %esi,%esi
8010407e:	74 76                	je     801040f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104080:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104086:	74 50                	je     801040d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 20 2d 11 80       	push   $0x80112d20
80104090:	e8 db 05 00 00       	call   80104670 <acquire>
    release(lk);
80104095:	89 34 24             	mov    %esi,(%esp)
80104098:	e8 73 05 00 00       	call   80104610 <release>
  p->chan = chan;
8010409d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a7:	e8 34 fc ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040b3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040ba:	e8 51 05 00 00       	call   80104610 <release>
    acquire(lk);
801040bf:	89 75 08             	mov    %esi,0x8(%ebp)
801040c2:	83 c4 10             	add    $0x10,%esp
}
801040c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
    acquire(lk);
801040cc:	e9 9f 05 00 00       	jmp    80104670 <acquire>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e2:	e8 f9 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f1:	5b                   	pop    %ebx
801040f2:	5e                   	pop    %esi
801040f3:	5f                   	pop    %edi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret    
    panic("sleep without lk");
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	68 fa 7b 10 80       	push   $0x80107bfa
801040fe:	e8 7d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	68 f4 7b 10 80       	push   $0x80107bf4
8010410b:	e8 70 c2 ff ff       	call   80100380 <panic>

80104110 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010411a:	68 20 2d 11 80       	push   $0x80112d20
8010411f:	e8 4c 05 00 00       	call   80104670 <acquire>
80104124:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104127:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010412c:	eb 0c                	jmp    8010413a <wakeup+0x2a>
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104138:	74 1c                	je     80104156 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <wakeup+0x20>
80104140:	3b 58 20             	cmp    0x20(%eax),%ebx
80104143:	75 eb                	jne    80104130 <wakeup+0x20>
      p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	83 c0 7c             	add    $0x7c,%eax
8010414f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104154:	75 e4                	jne    8010413a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104156:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010415d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104160:	c9                   	leave  
  release(&ptable.lock);
80104161:	e9 aa 04 00 00       	jmp    80104610 <release>
80104166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010417a:	68 20 2d 11 80       	push   $0x80112d20
8010417f:	e8 ec 04 00 00       	call   80104670 <acquire>
80104184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010418c:	eb 0c                	jmp    8010419a <kill+0x2a>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104198:	74 36                	je     801041d0 <kill+0x60>
    if(p->pid == pid){
8010419a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010419d:	75 f1                	jne    80104190 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010419f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041aa:	75 07                	jne    801041b3 <kill+0x43>
        p->state = RUNNABLE;
801041ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 20 2d 11 80       	push   $0x80112d20
801041bb:	e8 50 04 00 00       	call   80104610 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	31 c0                	xor    %eax,%eax
}
801041c8:	c9                   	leave  
801041c9:	c3                   	ret    
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	68 20 2d 11 80       	push   $0x80112d20
801041d8:	e8 33 04 00 00       	call   80104610 <release>
}
801041dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e8:	c9                   	leave  
801041e9:	c3                   	ret    
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041f8:	53                   	push   %ebx
801041f9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801041fe:	83 ec 3c             	sub    $0x3c,%esp
80104201:	eb 24                	jmp    80104227 <procdump+0x37>
80104203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104207:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 84 7e 10 80       	push   $0x80107e84
80104210:	e8 8b c4 ff ff       	call   801006a0 <cprintf>
80104215:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104218:	83 c3 7c             	add    $0x7c,%ebx
8010421b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104221:	0f 84 81 00 00 00    	je     801042a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104227:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010422a:	85 c0                	test   %eax,%eax
8010422c:	74 ea                	je     80104218 <procdump+0x28>
      state = "???";
8010422e:	ba 0b 7c 10 80       	mov    $0x80107c0b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104233:	83 f8 05             	cmp    $0x5,%eax
80104236:	77 11                	ja     80104249 <procdump+0x59>
80104238:	8b 14 85 cc 7c 10 80 	mov    -0x7fef8334(,%eax,4),%edx
      state = "???";
8010423f:	b8 0b 7c 10 80       	mov    $0x80107c0b,%eax
80104244:	85 d2                	test   %edx,%edx
80104246:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104249:	53                   	push   %ebx
8010424a:	52                   	push   %edx
8010424b:	ff 73 a4             	push   -0x5c(%ebx)
8010424e:	68 0f 7c 10 80       	push   $0x80107c0f
80104253:	e8 48 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010425f:	75 a7                	jne    80104208 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104261:	83 ec 08             	sub    $0x8,%esp
80104264:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104267:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010426a:	50                   	push   %eax
8010426b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010426e:	8b 40 0c             	mov    0xc(%eax),%eax
80104271:	83 c0 08             	add    $0x8,%eax
80104274:	50                   	push   %eax
80104275:	e8 46 02 00 00       	call   801044c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010427a:	83 c4 10             	add    $0x10,%esp
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
80104280:	8b 17                	mov    (%edi),%edx
80104282:	85 d2                	test   %edx,%edx
80104284:	74 82                	je     80104208 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104286:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104289:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010428c:	52                   	push   %edx
8010428d:	68 61 76 10 80       	push   $0x80107661
80104292:	e8 09 c4 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	39 fe                	cmp    %edi,%esi
8010429c:	75 e2                	jne    80104280 <procdump+0x90>
8010429e:	e9 65 ff ff ff       	jmp    80104208 <procdump+0x18>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
  }
}
801042a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ab:	5b                   	pop    %ebx
801042ac:	5e                   	pop    %esi
801042ad:	5f                   	pop    %edi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret    

801042b0 <cps>:

int cps()
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
  asm volatile("sti");
801042b5:	fb                   	sti    
	struct proc *p;
	sti();
	acquire(&ptable.lock);
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801042be:	be c0 4c 11 80       	mov    $0x80114cc0,%esi
801042c3:	68 20 2d 11 80       	push   $0x80112d20
801042c8:	e8 a3 03 00 00       	call   80104670 <acquire>
	cprintf("name \t pid \t state \t \n");
801042cd:	c7 04 24 18 7c 10 80 	movl   $0x80107c18,(%esp)
801042d4:	e8 c7 c3 ff ff       	call   801006a0 <cprintf>
	for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
801042d9:	83 c4 10             	add    $0x10,%esp
801042dc:	eb 13                	jmp    801042f1 <cps+0x41>
801042de:	66 90                	xchg   %ax,%ax
		if(p->state==SLEEPING)
			cprintf("%s \t %d  \t SLEEPING \t \n ",p->name, p->pid);
		else if(p->state==RUNNING)
801042e0:	83 f8 04             	cmp    $0x4,%eax
801042e3:	74 4b                	je     80104330 <cps+0x80>
			cprintf("%s \t %d  \t RUNNING \t \n ",p->name, p->pid);
		else if(p->state==RUNNABLE)
801042e5:	83 f8 03             	cmp    $0x3,%eax
801042e8:	74 66                	je     80104350 <cps+0xa0>
	for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
801042ea:	83 c3 7c             	add    $0x7c,%ebx
801042ed:	39 de                	cmp    %ebx,%esi
801042ef:	74 23                	je     80104314 <cps+0x64>
		if(p->state==SLEEPING)
801042f1:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042f4:	83 f8 02             	cmp    $0x2,%eax
801042f7:	75 e7                	jne    801042e0 <cps+0x30>
			cprintf("%s \t %d  \t SLEEPING \t \n ",p->name, p->pid);
801042f9:	83 ec 04             	sub    $0x4,%esp
801042fc:	ff 73 a4             	push   -0x5c(%ebx)
801042ff:	53                   	push   %ebx
	for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80104300:	83 c3 7c             	add    $0x7c,%ebx
			cprintf("%s \t %d  \t SLEEPING \t \n ",p->name, p->pid);
80104303:	68 2f 7c 10 80       	push   $0x80107c2f
80104308:	e8 93 c3 ff ff       	call   801006a0 <cprintf>
8010430d:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80104310:	39 de                	cmp    %ebx,%esi
80104312:	75 dd                	jne    801042f1 <cps+0x41>
			cprintf("%s \t %d  \t RUNNABLE \t \n ",p->name, p->pid);
	}
	release(&ptable.lock);
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	68 20 2d 11 80       	push   $0x80112d20
8010431c:	e8 ef 02 00 00       	call   80104610 <release>
	return 22;
}
80104321:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104324:	b8 16 00 00 00       	mov    $0x16,%eax
80104329:	5b                   	pop    %ebx
8010432a:	5e                   	pop    %esi
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("%s \t %d  \t RUNNING \t \n ",p->name, p->pid);
80104330:	83 ec 04             	sub    $0x4,%esp
80104333:	ff 73 a4             	push   -0x5c(%ebx)
80104336:	53                   	push   %ebx
80104337:	68 48 7c 10 80       	push   $0x80107c48
8010433c:	e8 5f c3 ff ff       	call   801006a0 <cprintf>
80104341:	83 c4 10             	add    $0x10,%esp
80104344:	eb a4                	jmp    801042ea <cps+0x3a>
80104346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("%s \t %d  \t RUNNABLE \t \n ",p->name, p->pid);
80104350:	83 ec 04             	sub    $0x4,%esp
80104353:	ff 73 a4             	push   -0x5c(%ebx)
80104356:	53                   	push   %ebx
80104357:	68 60 7c 10 80       	push   $0x80107c60
8010435c:	e8 3f c3 ff ff       	call   801006a0 <cprintf>
80104361:	83 c4 10             	add    $0x10,%esp
80104364:	eb 84                	jmp    801042ea <cps+0x3a>
80104366:	66 90                	xchg   %ax,%ax
80104368:	66 90                	xchg   %ax,%ax
8010436a:	66 90                	xchg   %ax,%ax
8010436c:	66 90                	xchg   %ax,%ax
8010436e:	66 90                	xchg   %ax,%ax

80104370 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010437a:	68 e4 7c 10 80       	push   $0x80107ce4
8010437f:	8d 43 04             	lea    0x4(%ebx),%eax
80104382:	50                   	push   %eax
80104383:	e8 18 01 00 00       	call   801044a0 <initlock>
  lk->name = name;
80104388:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010438b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104391:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104394:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010439b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010439e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a1:	c9                   	leave  
801043a2:	c3                   	ret    
801043a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043b8:	8d 73 04             	lea    0x4(%ebx),%esi
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	56                   	push   %esi
801043bf:	e8 ac 02 00 00       	call   80104670 <acquire>
  while (lk->locked) {
801043c4:	8b 13                	mov    (%ebx),%edx
801043c6:	83 c4 10             	add    $0x10,%esp
801043c9:	85 d2                	test   %edx,%edx
801043cb:	74 16                	je     801043e3 <acquiresleep+0x33>
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043d0:	83 ec 08             	sub    $0x8,%esp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	e8 76 fc ff ff       	call   80104050 <sleep>
  while (lk->locked) {
801043da:	8b 03                	mov    (%ebx),%eax
801043dc:	83 c4 10             	add    $0x10,%esp
801043df:	85 c0                	test   %eax,%eax
801043e1:	75 ed                	jne    801043d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043e9:	e8 92 f5 ff ff       	call   80103980 <myproc>
801043ee:	8b 40 10             	mov    0x10(%eax),%eax
801043f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043fa:	5b                   	pop    %ebx
801043fb:	5e                   	pop    %esi
801043fc:	5d                   	pop    %ebp
  release(&lk->lk);
801043fd:	e9 0e 02 00 00       	jmp    80104610 <release>
80104402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	8d 73 04             	lea    0x4(%ebx),%esi
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	56                   	push   %esi
8010441f:	e8 4c 02 00 00       	call   80104670 <acquire>
  lk->locked = 0;
80104424:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010442a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104431:	89 1c 24             	mov    %ebx,(%esp)
80104434:	e8 d7 fc ff ff       	call   80104110 <wakeup>
  release(&lk->lk);
80104439:	89 75 08             	mov    %esi,0x8(%ebp)
8010443c:	83 c4 10             	add    $0x10,%esp
}
8010443f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104442:	5b                   	pop    %ebx
80104443:	5e                   	pop    %esi
80104444:	5d                   	pop    %ebp
  release(&lk->lk);
80104445:	e9 c6 01 00 00       	jmp    80104610 <release>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	31 ff                	xor    %edi,%edi
80104456:	56                   	push   %esi
80104457:	53                   	push   %ebx
80104458:	83 ec 18             	sub    $0x18,%esp
8010445b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010445e:	8d 73 04             	lea    0x4(%ebx),%esi
80104461:	56                   	push   %esi
80104462:	e8 09 02 00 00       	call   80104670 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104467:	8b 03                	mov    (%ebx),%eax
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	85 c0                	test   %eax,%eax
8010446e:	75 18                	jne    80104488 <holdingsleep+0x38>
  release(&lk->lk);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	56                   	push   %esi
80104474:	e8 97 01 00 00       	call   80104610 <release>
  return r;
}
80104479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447c:	89 f8                	mov    %edi,%eax
8010447e:	5b                   	pop    %ebx
8010447f:	5e                   	pop    %esi
80104480:	5f                   	pop    %edi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret    
80104483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104487:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104488:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010448b:	e8 f0 f4 ff ff       	call   80103980 <myproc>
80104490:	39 58 10             	cmp    %ebx,0x10(%eax)
80104493:	0f 94 c0             	sete   %al
80104496:	0f b6 c0             	movzbl %al,%eax
80104499:	89 c7                	mov    %eax,%edi
8010449b:	eb d3                	jmp    80104470 <holdingsleep+0x20>
8010449d:	66 90                	xchg   %ax,%ax
8010449f:	90                   	nop

801044a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044bf:	90                   	nop

801044c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044c0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044c1:	31 d2                	xor    %edx,%edx
{
801044c3:	89 e5                	mov    %esp,%ebp
801044c5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044c6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044cc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801044cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044dc:	77 1a                	ja     801044f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044de:	8b 58 04             	mov    0x4(%eax),%ebx
801044e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044e4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044e7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044e9:	83 fa 0a             	cmp    $0xa,%edx
801044ec:	75 e2                	jne    801044d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave  
801044f2:	c3                   	ret    
801044f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f7:	90                   	nop
  for(; i < 10; i++)
801044f8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044fb:	8d 51 28             	lea    0x28(%ecx),%edx
801044fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104506:	83 c0 04             	add    $0x4,%eax
80104509:	39 d0                	cmp    %edx,%eax
8010450b:	75 f3                	jne    80104500 <getcallerpcs+0x40>
}
8010450d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104510:	c9                   	leave  
80104511:	c3                   	ret    
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104527:	9c                   	pushf  
80104528:	5b                   	pop    %ebx
  asm volatile("cli");
80104529:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010452a:	e8 d1 f3 ff ff       	call   80103900 <mycpu>
8010452f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104535:	85 c0                	test   %eax,%eax
80104537:	74 17                	je     80104550 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104539:	e8 c2 f3 ff ff       	call   80103900 <mycpu>
8010453e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104548:	c9                   	leave  
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104550:	e8 ab f3 ff ff       	call   80103900 <mycpu>
80104555:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010455b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104561:	eb d6                	jmp    80104539 <pushcli+0x19>
80104563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <popcli>:

void
popcli(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104576:	9c                   	pushf  
80104577:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104578:	f6 c4 02             	test   $0x2,%ah
8010457b:	75 35                	jne    801045b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010457d:	e8 7e f3 ff ff       	call   80103900 <mycpu>
80104582:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104589:	78 34                	js     801045bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010458b:	e8 70 f3 ff ff       	call   80103900 <mycpu>
80104590:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104596:	85 d2                	test   %edx,%edx
80104598:	74 06                	je     801045a0 <popcli+0x30>
    sti();
}
8010459a:	c9                   	leave  
8010459b:	c3                   	ret    
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045a0:	e8 5b f3 ff ff       	call   80103900 <mycpu>
801045a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045ab:	85 c0                	test   %eax,%eax
801045ad:	74 eb                	je     8010459a <popcli+0x2a>
  asm volatile("sti");
801045af:	fb                   	sti    
}
801045b0:	c9                   	leave  
801045b1:	c3                   	ret    
    panic("popcli - interruptible");
801045b2:	83 ec 0c             	sub    $0xc,%esp
801045b5:	68 ef 7c 10 80       	push   $0x80107cef
801045ba:	e8 c1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
801045bf:	83 ec 0c             	sub    $0xc,%esp
801045c2:	68 06 7d 10 80       	push   $0x80107d06
801045c7:	e8 b4 bd ff ff       	call   80100380 <panic>
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045d0 <holding>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 75 08             	mov    0x8(%ebp),%esi
801045d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045da:	e8 41 ff ff ff       	call   80104520 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045df:	8b 06                	mov    (%esi),%eax
801045e1:	85 c0                	test   %eax,%eax
801045e3:	75 0b                	jne    801045f0 <holding+0x20>
  popcli();
801045e5:	e8 86 ff ff ff       	call   80104570 <popcli>
}
801045ea:	89 d8                	mov    %ebx,%eax
801045ec:	5b                   	pop    %ebx
801045ed:	5e                   	pop    %esi
801045ee:	5d                   	pop    %ebp
801045ef:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801045f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801045f3:	e8 08 f3 ff ff       	call   80103900 <mycpu>
801045f8:	39 c3                	cmp    %eax,%ebx
801045fa:	0f 94 c3             	sete   %bl
  popcli();
801045fd:	e8 6e ff ff ff       	call   80104570 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104602:	0f b6 db             	movzbl %bl,%ebx
}
80104605:	89 d8                	mov    %ebx,%eax
80104607:	5b                   	pop    %ebx
80104608:	5e                   	pop    %esi
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret    
8010460b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop

80104610 <release>:
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104618:	e8 03 ff ff ff       	call   80104520 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010461d:	8b 03                	mov    (%ebx),%eax
8010461f:	85 c0                	test   %eax,%eax
80104621:	75 15                	jne    80104638 <release+0x28>
  popcli();
80104623:	e8 48 ff ff ff       	call   80104570 <popcli>
    panic("release");
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	68 0d 7d 10 80       	push   $0x80107d0d
80104630:	e8 4b bd ff ff       	call   80100380 <panic>
80104635:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104638:	8b 73 08             	mov    0x8(%ebx),%esi
8010463b:	e8 c0 f2 ff ff       	call   80103900 <mycpu>
80104640:	39 c6                	cmp    %eax,%esi
80104642:	75 df                	jne    80104623 <release+0x13>
  popcli();
80104644:	e8 27 ff ff ff       	call   80104570 <popcli>
  lk->pcs[0] = 0;
80104649:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104650:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104657:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010465c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104662:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104665:	5b                   	pop    %ebx
80104666:	5e                   	pop    %esi
80104667:	5d                   	pop    %ebp
  popcli();
80104668:	e9 03 ff ff ff       	jmp    80104570 <popcli>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi

80104670 <acquire>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104677:	e8 a4 fe ff ff       	call   80104520 <pushcli>
  if(holding(lk))
8010467c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010467f:	e8 9c fe ff ff       	call   80104520 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104684:	8b 03                	mov    (%ebx),%eax
80104686:	85 c0                	test   %eax,%eax
80104688:	75 7e                	jne    80104708 <acquire+0x98>
  popcli();
8010468a:	e8 e1 fe ff ff       	call   80104570 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010468f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104698:	8b 55 08             	mov    0x8(%ebp),%edx
8010469b:	89 c8                	mov    %ecx,%eax
8010469d:	f0 87 02             	lock xchg %eax,(%edx)
801046a0:	85 c0                	test   %eax,%eax
801046a2:	75 f4                	jne    80104698 <acquire+0x28>
  __sync_synchronize();
801046a4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046ac:	e8 4f f2 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801046b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801046b4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801046b6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801046b9:	31 c0                	xor    %eax,%eax
801046bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801046c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046cc:	77 1a                	ja     801046e8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801046ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801046d1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801046d5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801046d8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801046da:	83 f8 0a             	cmp    $0xa,%eax
801046dd:	75 e1                	jne    801046c0 <acquire+0x50>
}
801046df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e2:	c9                   	leave  
801046e3:	c3                   	ret    
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801046e8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801046ec:	8d 51 34             	lea    0x34(%ecx),%edx
801046ef:	90                   	nop
    pcs[i] = 0;
801046f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046f6:	83 c0 04             	add    $0x4,%eax
801046f9:	39 c2                	cmp    %eax,%edx
801046fb:	75 f3                	jne    801046f0 <acquire+0x80>
}
801046fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104700:	c9                   	leave  
80104701:	c3                   	ret    
80104702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104708:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010470b:	e8 f0 f1 ff ff       	call   80103900 <mycpu>
80104710:	39 c3                	cmp    %eax,%ebx
80104712:	0f 85 72 ff ff ff    	jne    8010468a <acquire+0x1a>
  popcli();
80104718:	e8 53 fe ff ff       	call   80104570 <popcli>
    panic("acquire");
8010471d:	83 ec 0c             	sub    $0xc,%esp
80104720:	68 15 7d 10 80       	push   $0x80107d15
80104725:	e8 56 bc ff ff       	call   80100380 <panic>
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	66 90                	xchg   %ax,%ax
8010472e:	66 90                	xchg   %ax,%ax

80104730 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 55 08             	mov    0x8(%ebp),%edx
80104737:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473a:	53                   	push   %ebx
8010473b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010473e:	89 d7                	mov    %edx,%edi
80104740:	09 cf                	or     %ecx,%edi
80104742:	83 e7 03             	and    $0x3,%edi
80104745:	75 29                	jne    80104770 <memset+0x40>
    c &= 0xFF;
80104747:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010474a:	c1 e0 18             	shl    $0x18,%eax
8010474d:	89 fb                	mov    %edi,%ebx
8010474f:	c1 e9 02             	shr    $0x2,%ecx
80104752:	c1 e3 10             	shl    $0x10,%ebx
80104755:	09 d8                	or     %ebx,%eax
80104757:	09 f8                	or     %edi,%eax
80104759:	c1 e7 08             	shl    $0x8,%edi
8010475c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010475e:	89 d7                	mov    %edx,%edi
80104760:	fc                   	cld    
80104761:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104763:	5b                   	pop    %ebx
80104764:	89 d0                	mov    %edx,%eax
80104766:	5f                   	pop    %edi
80104767:	5d                   	pop    %ebp
80104768:	c3                   	ret    
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104770:	89 d7                	mov    %edx,%edi
80104772:	fc                   	cld    
80104773:	f3 aa                	rep stos %al,%es:(%edi)
80104775:	5b                   	pop    %ebx
80104776:	89 d0                	mov    %edx,%eax
80104778:	5f                   	pop    %edi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010477f:	90                   	nop

80104780 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	8b 75 10             	mov    0x10(%ebp),%esi
80104787:	8b 55 08             	mov    0x8(%ebp),%edx
8010478a:	53                   	push   %ebx
8010478b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010478e:	85 f6                	test   %esi,%esi
80104790:	74 2e                	je     801047c0 <memcmp+0x40>
80104792:	01 c6                	add    %eax,%esi
80104794:	eb 14                	jmp    801047aa <memcmp+0x2a>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801047a0:	83 c0 01             	add    $0x1,%eax
801047a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801047a6:	39 f0                	cmp    %esi,%eax
801047a8:	74 16                	je     801047c0 <memcmp+0x40>
    if(*s1 != *s2)
801047aa:	0f b6 0a             	movzbl (%edx),%ecx
801047ad:	0f b6 18             	movzbl (%eax),%ebx
801047b0:	38 d9                	cmp    %bl,%cl
801047b2:	74 ec                	je     801047a0 <memcmp+0x20>
      return *s1 - *s2;
801047b4:	0f b6 c1             	movzbl %cl,%eax
801047b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801047b9:	5b                   	pop    %ebx
801047ba:	5e                   	pop    %esi
801047bb:	5d                   	pop    %ebp
801047bc:	c3                   	ret    
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	5b                   	pop    %ebx
  return 0;
801047c1:	31 c0                	xor    %eax,%eax
}
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	8b 55 08             	mov    0x8(%ebp),%edx
801047d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047da:	56                   	push   %esi
801047db:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047de:	39 d6                	cmp    %edx,%esi
801047e0:	73 26                	jae    80104808 <memmove+0x38>
801047e2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801047e5:	39 fa                	cmp    %edi,%edx
801047e7:	73 1f                	jae    80104808 <memmove+0x38>
801047e9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801047ec:	85 c9                	test   %ecx,%ecx
801047ee:	74 0c                	je     801047fc <memmove+0x2c>
      *--d = *--s;
801047f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047f7:	83 e8 01             	sub    $0x1,%eax
801047fa:	73 f4                	jae    801047f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047fc:	5e                   	pop    %esi
801047fd:	89 d0                	mov    %edx,%eax
801047ff:	5f                   	pop    %edi
80104800:	5d                   	pop    %ebp
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104808:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010480b:	89 d7                	mov    %edx,%edi
8010480d:	85 c9                	test   %ecx,%ecx
8010480f:	74 eb                	je     801047fc <memmove+0x2c>
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104818:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104819:	39 c6                	cmp    %eax,%esi
8010481b:	75 fb                	jne    80104818 <memmove+0x48>
}
8010481d:	5e                   	pop    %esi
8010481e:	89 d0                	mov    %edx,%eax
80104820:	5f                   	pop    %edi
80104821:	5d                   	pop    %ebp
80104822:	c3                   	ret    
80104823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104830:	eb 9e                	jmp    801047d0 <memmove>
80104832:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	8b 75 10             	mov    0x10(%ebp),%esi
80104847:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010484a:	53                   	push   %ebx
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010484e:	85 f6                	test   %esi,%esi
80104850:	74 2e                	je     80104880 <strncmp+0x40>
80104852:	01 d6                	add    %edx,%esi
80104854:	eb 18                	jmp    8010486e <strncmp+0x2e>
80104856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485d:	8d 76 00             	lea    0x0(%esi),%esi
80104860:	38 d8                	cmp    %bl,%al
80104862:	75 14                	jne    80104878 <strncmp+0x38>
    n--, p++, q++;
80104864:	83 c2 01             	add    $0x1,%edx
80104867:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010486a:	39 f2                	cmp    %esi,%edx
8010486c:	74 12                	je     80104880 <strncmp+0x40>
8010486e:	0f b6 01             	movzbl (%ecx),%eax
80104871:	0f b6 1a             	movzbl (%edx),%ebx
80104874:	84 c0                	test   %al,%al
80104876:	75 e8                	jne    80104860 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104878:	29 d8                	sub    %ebx,%eax
}
8010487a:	5b                   	pop    %ebx
8010487b:	5e                   	pop    %esi
8010487c:	5d                   	pop    %ebp
8010487d:	c3                   	ret    
8010487e:	66 90                	xchg   %ax,%ax
80104880:	5b                   	pop    %ebx
    return 0;
80104881:	31 c0                	xor    %eax,%eax
}
80104883:	5e                   	pop    %esi
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret    
80104886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	8b 75 08             	mov    0x8(%ebp),%esi
80104898:	53                   	push   %ebx
80104899:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010489c:	89 f0                	mov    %esi,%eax
8010489e:	eb 15                	jmp    801048b5 <strncpy+0x25>
801048a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801048a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048a7:	83 c0 01             	add    $0x1,%eax
801048aa:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801048ae:	88 50 ff             	mov    %dl,-0x1(%eax)
801048b1:	84 d2                	test   %dl,%dl
801048b3:	74 09                	je     801048be <strncpy+0x2e>
801048b5:	89 cb                	mov    %ecx,%ebx
801048b7:	83 e9 01             	sub    $0x1,%ecx
801048ba:	85 db                	test   %ebx,%ebx
801048bc:	7f e2                	jg     801048a0 <strncpy+0x10>
    ;
  while(n-- > 0)
801048be:	89 c2                	mov    %eax,%edx
801048c0:	85 c9                	test   %ecx,%ecx
801048c2:	7e 17                	jle    801048db <strncpy+0x4b>
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048c8:	83 c2 01             	add    $0x1,%edx
801048cb:	89 c1                	mov    %eax,%ecx
801048cd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801048d1:	29 d1                	sub    %edx,%ecx
801048d3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801048d7:	85 c9                	test   %ecx,%ecx
801048d9:	7f ed                	jg     801048c8 <strncpy+0x38>
  return os;
}
801048db:	5b                   	pop    %ebx
801048dc:	89 f0                	mov    %esi,%eax
801048de:	5e                   	pop    %esi
801048df:	5f                   	pop    %edi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret    
801048e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 55 10             	mov    0x10(%ebp),%edx
801048f7:	8b 75 08             	mov    0x8(%ebp),%esi
801048fa:	53                   	push   %ebx
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048fe:	85 d2                	test   %edx,%edx
80104900:	7e 25                	jle    80104927 <safestrcpy+0x37>
80104902:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104906:	89 f2                	mov    %esi,%edx
80104908:	eb 16                	jmp    80104920 <safestrcpy+0x30>
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104910:	0f b6 08             	movzbl (%eax),%ecx
80104913:	83 c0 01             	add    $0x1,%eax
80104916:	83 c2 01             	add    $0x1,%edx
80104919:	88 4a ff             	mov    %cl,-0x1(%edx)
8010491c:	84 c9                	test   %cl,%cl
8010491e:	74 04                	je     80104924 <safestrcpy+0x34>
80104920:	39 d8                	cmp    %ebx,%eax
80104922:	75 ec                	jne    80104910 <safestrcpy+0x20>
    ;
  *s = 0;
80104924:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104927:	89 f0                	mov    %esi,%eax
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <strlen>:

int
strlen(const char *s)
{
80104930:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104931:	31 c0                	xor    %eax,%eax
{
80104933:	89 e5                	mov    %esp,%ebp
80104935:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104938:	80 3a 00             	cmpb   $0x0,(%edx)
8010493b:	74 0c                	je     80104949 <strlen+0x19>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
80104940:	83 c0 01             	add    $0x1,%eax
80104943:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104947:	75 f7                	jne    80104940 <strlen+0x10>
    ;
  return n;
}
80104949:	5d                   	pop    %ebp
8010494a:	c3                   	ret    

8010494b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010494b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010494f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104953:	55                   	push   %ebp
  pushl %ebx
80104954:	53                   	push   %ebx
  pushl %esi
80104955:	56                   	push   %esi
  pushl %edi
80104956:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104957:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104959:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010495b:	5f                   	pop    %edi
  popl %esi
8010495c:	5e                   	pop    %esi
  popl %ebx
8010495d:	5b                   	pop    %ebx
  popl %ebp
8010495e:	5d                   	pop    %ebp
  ret
8010495f:	c3                   	ret    

80104960 <fetchint>:
// Arguments on the stack, from the user call to the C library system call function. 
// The saved user %esp points to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010496a:	e8 11 f0 ff ff       	call   80103980 <myproc>

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
8010496f:	8b 00                	mov    (%eax),%eax
80104971:	39 d8                	cmp    %ebx,%eax
80104973:	76 1b                	jbe    80104990 <fetchint+0x30>
80104975:	8d 53 04             	lea    0x4(%ebx),%edx
80104978:	39 d0                	cmp    %edx,%eax
8010497a:	72 14                	jb     80104990 <fetchint+0x30>
    return -1;
  *ip = *(int *)(addr);
8010497c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497f:	8b 13                	mov    (%ebx),%edx
80104981:	89 10                	mov    %edx,(%eax)
  return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104988:	c9                   	leave  
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	eb ee                	jmp    80104985 <fetchint+0x25>
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 04             	sub    $0x4,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049aa:	e8 d1 ef ff ff       	call   80103980 <myproc>

  if (addr >= curproc->sz)
801049af:	39 18                	cmp    %ebx,(%eax)
801049b1:	76 2d                	jbe    801049e0 <fetchstr+0x40>
    return -1;
  *pp = (char *)addr;
801049b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801049b6:	89 1a                	mov    %ebx,(%edx)
  ep = (char *)curproc->sz;
801049b8:	8b 10                	mov    (%eax),%edx
  for (s = *pp; s < ep; s++) {
801049ba:	39 d3                	cmp    %edx,%ebx
801049bc:	73 22                	jae    801049e0 <fetchstr+0x40>
801049be:	89 d8                	mov    %ebx,%eax
801049c0:	eb 0d                	jmp    801049cf <fetchstr+0x2f>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	83 c0 01             	add    $0x1,%eax
801049cb:	39 c2                	cmp    %eax,%edx
801049cd:	76 11                	jbe    801049e0 <fetchstr+0x40>
    if (*s == 0)
801049cf:	80 38 00             	cmpb   $0x0,(%eax)
801049d2:	75 f4                	jne    801049c8 <fetchstr+0x28>
      return s - *pp;
801049d4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801049d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d9:	c9                   	leave  
801049da:	c3                   	ret    
801049db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049df:	90                   	nop
801049e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801049e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e8:	c9                   	leave  
801049e9:	c3                   	ret    
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801049f5:	e8 86 ef ff ff       	call   80103980 <myproc>
801049fa:	8b 55 08             	mov    0x8(%ebp),%edx
801049fd:	8b 40 18             	mov    0x18(%eax),%eax
80104a00:	8b 40 44             	mov    0x44(%eax),%eax
80104a03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a06:	e8 75 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104a0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104a0e:	8b 00                	mov    (%eax),%eax
80104a10:	39 c6                	cmp    %eax,%esi
80104a12:	73 1c                	jae    80104a30 <argint+0x40>
80104a14:	8d 53 08             	lea    0x8(%ebx),%edx
80104a17:	39 d0                	cmp    %edx,%eax
80104a19:	72 15                	jb     80104a30 <argint+0x40>
  *ip = *(int *)(addr);
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a21:	89 10                	mov    %edx,(%eax)
  return 0;
80104a23:	31 c0                	xor    %eax,%eax
}
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
80104a28:	c3                   	ret    
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104a35:	eb ee                	jmp    80104a25 <argint+0x35>
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a49:	e8 32 ef ff ff       	call   80103980 <myproc>
80104a4e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104a50:	e8 2b ef ff ff       	call   80103980 <myproc>
80104a55:	8b 55 08             	mov    0x8(%ebp),%edx
80104a58:	8b 40 18             	mov    0x18(%eax),%eax
80104a5b:	8b 40 44             	mov    0x44(%eax),%eax
80104a5e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a61:	e8 1a ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104a66:	8d 7b 04             	lea    0x4(%ebx),%edi
  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104a69:	8b 00                	mov    (%eax),%eax
80104a6b:	39 c7                	cmp    %eax,%edi
80104a6d:	73 31                	jae    80104aa0 <argptr+0x60>
80104a6f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a72:	39 c8                	cmp    %ecx,%eax
80104a74:	72 2a                	jb     80104aa0 <argptr+0x60>

  if (argint(n, &i) < 0)
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80104a76:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int *)(addr);
80104a79:	8b 43 04             	mov    0x4(%ebx),%eax
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80104a7c:	85 d2                	test   %edx,%edx
80104a7e:	78 20                	js     80104aa0 <argptr+0x60>
80104a80:	8b 16                	mov    (%esi),%edx
80104a82:	39 c2                	cmp    %eax,%edx
80104a84:	76 1a                	jbe    80104aa0 <argptr+0x60>
80104a86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a89:	01 c3                	add    %eax,%ebx
80104a8b:	39 da                	cmp    %ebx,%edx
80104a8d:	72 11                	jb     80104aa0 <argptr+0x60>
    return -1;
  *pp = (char *)i;
80104a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a92:	89 02                	mov    %eax,(%edx)
  return 0;
80104a94:	31 c0                	xor    %eax,%eax
}
80104a96:	83 c4 0c             	add    $0xc,%esp
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5f                   	pop    %edi
80104a9c:	5d                   	pop    %ebp
80104a9d:	c3                   	ret    
80104a9e:	66 90                	xchg   %ax,%ax
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	eb ef                	jmp    80104a96 <argptr+0x56>
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104ab5:	e8 c6 ee ff ff       	call   80103980 <myproc>
80104aba:	8b 55 08             	mov    0x8(%ebp),%edx
80104abd:	8b 40 18             	mov    0x18(%eax),%eax
80104ac0:	8b 40 44             	mov    0x44(%eax),%eax
80104ac3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ac6:	e8 b5 ee ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104acb:	8d 73 04             	lea    0x4(%ebx),%esi
  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104ace:	8b 00                	mov    (%eax),%eax
80104ad0:	39 c6                	cmp    %eax,%esi
80104ad2:	73 44                	jae    80104b18 <argstr+0x68>
80104ad4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ad7:	39 d0                	cmp    %edx,%eax
80104ad9:	72 3d                	jb     80104b18 <argstr+0x68>
  *ip = *(int *)(addr);
80104adb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104ade:	e8 9d ee ff ff       	call   80103980 <myproc>
  if (addr >= curproc->sz)
80104ae3:	3b 18                	cmp    (%eax),%ebx
80104ae5:	73 31                	jae    80104b18 <argstr+0x68>
  *pp = (char *)addr;
80104ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aea:	89 1a                	mov    %ebx,(%edx)
  ep = (char *)curproc->sz;
80104aec:	8b 10                	mov    (%eax),%edx
  for (s = *pp; s < ep; s++) {
80104aee:	39 d3                	cmp    %edx,%ebx
80104af0:	73 26                	jae    80104b18 <argstr+0x68>
80104af2:	89 d8                	mov    %ebx,%eax
80104af4:	eb 11                	jmp    80104b07 <argstr+0x57>
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
80104b00:	83 c0 01             	add    $0x1,%eax
80104b03:	39 c2                	cmp    %eax,%edx
80104b05:	76 11                	jbe    80104b18 <argstr+0x68>
    if (*s == 0)
80104b07:	80 38 00             	cmpb   $0x0,(%eax)
80104b0a:	75 f4                	jne    80104b00 <argstr+0x50>
      return s - *pp;
80104b0c:	29 d8                	sub    %ebx,%eax
  int addr;
  if (argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b0e:	5b                   	pop    %ebx
80104b0f:	5e                   	pop    %esi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b18:	5b                   	pop    %ebx
    return -1;
80104b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b1e:	5e                   	pop    %esi
80104b1f:	5d                   	pop    %ebp
80104b20:	c3                   	ret    
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop

80104b30 <syscall>:
  [SYS_describe]	sys_describe,
};

// System call dispatcher
void syscall(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b37:	e8 44 ee ff ff       	call   80103980 <myproc>
80104b3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b3e:	8b 40 18             	mov    0x18(%eax),%eax
80104b41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b47:	83 fa 17             	cmp    $0x17,%edx
80104b4a:	77 24                	ja     80104b70 <syscall+0x40>
80104b4c:	8b 14 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%edx
80104b53:	85 d2                	test   %edx,%edx
80104b55:	74 19                	je     80104b70 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b57:	ff d2                	call   *%edx
80104b59:	89 c2                	mov    %eax,%edx
80104b5b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b5e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b64:	c9                   	leave  
80104b65:	c3                   	ret    
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b70:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b71:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b74:	50                   	push   %eax
80104b75:	ff 73 10             	push   0x10(%ebx)
80104b78:	68 1d 7d 10 80       	push   $0x80107d1d
80104b7d:	e8 1e bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104b82:	8b 43 18             	mov    0x18(%ebx),%eax
80104b85:	83 c4 10             	add    $0x10,%esp
80104b88:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b92:	c9                   	leave  
80104b93:	c3                   	ret    
80104b94:	66 90                	xchg   %ax,%ax
80104b96:	66 90                	xchg   %ax,%ax
80104b98:	66 90                	xchg   %ax,%ax
80104b9a:	66 90                	xchg   %ax,%ax
80104b9c:	66 90                	xchg   %ax,%ax
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ba5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ba8:	53                   	push   %ebx
80104ba9:	83 ec 34             	sub    $0x34,%esp
80104bac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104bb2:	57                   	push   %edi
80104bb3:	50                   	push   %eax
{
80104bb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104bb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bba:	e8 01 d5 ff ff       	call   801020c0 <nameiparent>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	85 c0                	test   %eax,%eax
80104bc4:	0f 84 46 01 00 00    	je     80104d10 <create+0x170>
    return 0;
  ilock(dp);
80104bca:	83 ec 0c             	sub    $0xc,%esp
80104bcd:	89 c3                	mov    %eax,%ebx
80104bcf:	50                   	push   %eax
80104bd0:	e8 ab cb ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104bd5:	83 c4 0c             	add    $0xc,%esp
80104bd8:	6a 00                	push   $0x0
80104bda:	57                   	push   %edi
80104bdb:	53                   	push   %ebx
80104bdc:	e8 ff d0 ff ff       	call   80101ce0 <dirlookup>
80104be1:	83 c4 10             	add    $0x10,%esp
80104be4:	89 c6                	mov    %eax,%esi
80104be6:	85 c0                	test   %eax,%eax
80104be8:	74 56                	je     80104c40 <create+0xa0>
    iunlockput(dp);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	53                   	push   %ebx
80104bee:	e8 1d ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104bf3:	89 34 24             	mov    %esi,(%esp)
80104bf6:	e8 85 cb ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bfb:	83 c4 10             	add    $0x10,%esp
80104bfe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c03:	75 1b                	jne    80104c20 <create+0x80>
80104c05:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c0a:	75 14                	jne    80104c20 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c0f:	89 f0                	mov    %esi,%eax
80104c11:	5b                   	pop    %ebx
80104c12:	5e                   	pop    %esi
80104c13:	5f                   	pop    %edi
80104c14:	5d                   	pop    %ebp
80104c15:	c3                   	ret    
80104c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c20:	83 ec 0c             	sub    $0xc,%esp
80104c23:	56                   	push   %esi
    return 0;
80104c24:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c26:	e8 e5 cd ff ff       	call   80101a10 <iunlockput>
    return 0;
80104c2b:	83 c4 10             	add    $0x10,%esp
}
80104c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c31:	89 f0                	mov    %esi,%eax
80104c33:	5b                   	pop    %ebx
80104c34:	5e                   	pop    %esi
80104c35:	5f                   	pop    %edi
80104c36:	5d                   	pop    %ebp
80104c37:	c3                   	ret    
80104c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c44:	83 ec 08             	sub    $0x8,%esp
80104c47:	50                   	push   %eax
80104c48:	ff 33                	push   (%ebx)
80104c4a:	e8 c1 c9 ff ff       	call   80101610 <ialloc>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	89 c6                	mov    %eax,%esi
80104c54:	85 c0                	test   %eax,%eax
80104c56:	0f 84 cd 00 00 00    	je     80104d29 <create+0x189>
  ilock(ip);
80104c5c:	83 ec 0c             	sub    $0xc,%esp
80104c5f:	50                   	push   %eax
80104c60:	e8 1b cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104c65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c69:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c71:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c75:	b8 01 00 00 00       	mov    $0x1,%eax
80104c7a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c7e:	89 34 24             	mov    %esi,(%esp)
80104c81:	e8 4a ca ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c86:	83 c4 10             	add    $0x10,%esp
80104c89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c8e:	74 30                	je     80104cc0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c90:	83 ec 04             	sub    $0x4,%esp
80104c93:	ff 76 04             	push   0x4(%esi)
80104c96:	57                   	push   %edi
80104c97:	53                   	push   %ebx
80104c98:	e8 43 d3 ff ff       	call   80101fe0 <dirlink>
80104c9d:	83 c4 10             	add    $0x10,%esp
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	78 78                	js     80104d1c <create+0x17c>
  iunlockput(dp);
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	53                   	push   %ebx
80104ca8:	e8 63 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104cad:	83 c4 10             	add    $0x10,%esp
}
80104cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cb3:	89 f0                	mov    %esi,%eax
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5f                   	pop    %edi
80104cb8:	5d                   	pop    %ebp
80104cb9:	c3                   	ret    
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104cc0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104cc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cc8:	53                   	push   %ebx
80104cc9:	e8 02 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cce:	83 c4 0c             	add    $0xc,%esp
80104cd1:	ff 76 04             	push   0x4(%esi)
80104cd4:	68 c0 7d 10 80       	push   $0x80107dc0
80104cd9:	56                   	push   %esi
80104cda:	e8 01 d3 ff ff       	call   80101fe0 <dirlink>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	78 18                	js     80104cfe <create+0x15e>
80104ce6:	83 ec 04             	sub    $0x4,%esp
80104ce9:	ff 73 04             	push   0x4(%ebx)
80104cec:	68 bf 7d 10 80       	push   $0x80107dbf
80104cf1:	56                   	push   %esi
80104cf2:	e8 e9 d2 ff ff       	call   80101fe0 <dirlink>
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	79 92                	jns    80104c90 <create+0xf0>
      panic("create dots");
80104cfe:	83 ec 0c             	sub    $0xc,%esp
80104d01:	68 b3 7d 10 80       	push   $0x80107db3
80104d06:	e8 75 b6 ff ff       	call   80100380 <panic>
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop
}
80104d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d13:	31 f6                	xor    %esi,%esi
}
80104d15:	5b                   	pop    %ebx
80104d16:	89 f0                	mov    %esi,%eax
80104d18:	5e                   	pop    %esi
80104d19:	5f                   	pop    %edi
80104d1a:	5d                   	pop    %ebp
80104d1b:	c3                   	ret    
    panic("create: dirlink");
80104d1c:	83 ec 0c             	sub    $0xc,%esp
80104d1f:	68 c2 7d 10 80       	push   $0x80107dc2
80104d24:	e8 57 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d29:	83 ec 0c             	sub    $0xc,%esp
80104d2c:	68 a4 7d 10 80       	push   $0x80107da4
80104d31:	e8 4a b6 ff ff       	call   80100380 <panic>
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

80104d40 <sys_dup>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104d48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d4b:	50                   	push   %eax
80104d4c:	6a 00                	push   $0x0
80104d4e:	e8 9d fc ff ff       	call   801049f0 <argint>
80104d53:	83 c4 10             	add    $0x10,%esp
80104d56:	85 c0                	test   %eax,%eax
80104d58:	78 36                	js     80104d90 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d5e:	77 30                	ja     80104d90 <sys_dup+0x50>
80104d60:	e8 1b ec ff ff       	call   80103980 <myproc>
80104d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d6c:	85 f6                	test   %esi,%esi
80104d6e:	74 20                	je     80104d90 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d70:	e8 0b ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d75:	31 db                	xor    %ebx,%ebx
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d84:	85 d2                	test   %edx,%edx
80104d86:	74 18                	je     80104da0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d88:	83 c3 01             	add    $0x1,%ebx
80104d8b:	83 fb 10             	cmp    $0x10,%ebx
80104d8e:	75 f0                	jne    80104d80 <sys_dup+0x40>
}
80104d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d98:	89 d8                	mov    %ebx,%eax
80104d9a:	5b                   	pop    %ebx
80104d9b:	5e                   	pop    %esi
80104d9c:	5d                   	pop    %ebp
80104d9d:	c3                   	ret    
80104d9e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104da0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104da3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104da7:	56                   	push   %esi
80104da8:	e8 f3 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104dad:	83 c4 10             	add    $0x10,%esp
}
80104db0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db3:	89 d8                	mov    %ebx,%eax
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5d                   	pop    %ebp
80104db8:	c3                   	ret    
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <sys_read>:
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dc5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104dc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dcb:	53                   	push   %ebx
80104dcc:	6a 00                	push   $0x0
80104dce:	e8 1d fc ff ff       	call   801049f0 <argint>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 5e                	js     80104e38 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dde:	77 58                	ja     80104e38 <sys_read+0x78>
80104de0:	e8 9b eb ff ff       	call   80103980 <myproc>
80104de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104de8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dec:	85 f6                	test   %esi,%esi
80104dee:	74 48                	je     80104e38 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104df0:	83 ec 08             	sub    $0x8,%esp
80104df3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104df6:	50                   	push   %eax
80104df7:	6a 02                	push   $0x2
80104df9:	e8 f2 fb ff ff       	call   801049f0 <argint>
80104dfe:	83 c4 10             	add    $0x10,%esp
80104e01:	85 c0                	test   %eax,%eax
80104e03:	78 33                	js     80104e38 <sys_read+0x78>
80104e05:	83 ec 04             	sub    $0x4,%esp
80104e08:	ff 75 f0             	push   -0x10(%ebp)
80104e0b:	53                   	push   %ebx
80104e0c:	6a 01                	push   $0x1
80104e0e:	e8 2d fc ff ff       	call   80104a40 <argptr>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	78 1e                	js     80104e38 <sys_read+0x78>
  return fileread(f, p, n);
80104e1a:	83 ec 04             	sub    $0x4,%esp
80104e1d:	ff 75 f0             	push   -0x10(%ebp)
80104e20:	ff 75 f4             	push   -0xc(%ebp)
80104e23:	56                   	push   %esi
80104e24:	e8 f7 c1 ff ff       	call   80101020 <fileread>
80104e29:	83 c4 10             	add    $0x10,%esp
}
80104e2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e2f:	5b                   	pop    %ebx
80104e30:	5e                   	pop    %esi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e37:	90                   	nop
    return -1;
80104e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3d:	eb ed                	jmp    80104e2c <sys_read+0x6c>
80104e3f:	90                   	nop

80104e40 <sys_write>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	53                   	push   %ebx
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 9d fb ff ff       	call   801049f0 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 5e                	js     80104eb8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 58                	ja     80104eb8 <sys_write+0x78>
80104e60:	e8 1b eb ff ff       	call   80103980 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e6c:	85 f6                	test   %esi,%esi
80104e6e:	74 48                	je     80104eb8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e70:	83 ec 08             	sub    $0x8,%esp
80104e73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e76:	50                   	push   %eax
80104e77:	6a 02                	push   $0x2
80104e79:	e8 72 fb ff ff       	call   801049f0 <argint>
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	85 c0                	test   %eax,%eax
80104e83:	78 33                	js     80104eb8 <sys_write+0x78>
80104e85:	83 ec 04             	sub    $0x4,%esp
80104e88:	ff 75 f0             	push   -0x10(%ebp)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 01                	push   $0x1
80104e8e:	e8 ad fb ff ff       	call   80104a40 <argptr>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 1e                	js     80104eb8 <sys_write+0x78>
  return filewrite(f, p, n);
80104e9a:	83 ec 04             	sub    $0x4,%esp
80104e9d:	ff 75 f0             	push   -0x10(%ebp)
80104ea0:	ff 75 f4             	push   -0xc(%ebp)
80104ea3:	56                   	push   %esi
80104ea4:	e8 07 c2 ff ff       	call   801010b0 <filewrite>
80104ea9:	83 c4 10             	add    $0x10,%esp
}
80104eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb7:	90                   	nop
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ed                	jmp    80104eac <sys_write+0x6c>
80104ebf:	90                   	nop

80104ec0 <sys_close>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	50                   	push   %eax
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 1d fb ff ff       	call   801049f0 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 3e                	js     80104f18 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 38                	ja     80104f18 <sys_close+0x58>
80104ee0:	e8 9b ea ff ff       	call   80103980 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104eeb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104eef:	85 f6                	test   %esi,%esi
80104ef1:	74 25                	je     80104f18 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104ef3:	e8 88 ea ff ff       	call   80103980 <myproc>
  fileclose(f);
80104ef8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104efb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f02:	00 
  fileclose(f);
80104f03:	56                   	push   %esi
80104f04:	e8 e7 bf ff ff       	call   80100ef0 <fileclose>
  return 0;
80104f09:	83 c4 10             	add    $0x10,%esp
80104f0c:	31 c0                	xor    %eax,%eax
}
80104f0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f11:	5b                   	pop    %ebx
80104f12:	5e                   	pop    %esi
80104f13:	5d                   	pop    %ebp
80104f14:	c3                   	ret    
80104f15:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f1d:	eb ef                	jmp    80104f0e <sys_close+0x4e>
80104f1f:	90                   	nop

80104f20 <sys_fstat>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 bd fa ff ff       	call   801049f0 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 46                	js     80104f80 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 40                	ja     80104f80 <sys_fstat+0x60>
80104f40:	e8 3b ea ff ff       	call   80103980 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 30                	je     80104f80 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f50:	83 ec 04             	sub    $0x4,%esp
80104f53:	6a 14                	push   $0x14
80104f55:	53                   	push   %ebx
80104f56:	6a 01                	push   $0x1
80104f58:	e8 e3 fa ff ff       	call   80104a40 <argptr>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 1c                	js     80104f80 <sys_fstat+0x60>
  return filestat(f, st);
80104f64:	83 ec 08             	sub    $0x8,%esp
80104f67:	ff 75 f4             	push   -0xc(%ebp)
80104f6a:	56                   	push   %esi
80104f6b:	e8 60 c0 ff ff       	call   80100fd0 <filestat>
80104f70:	83 c4 10             	add    $0x10,%esp
}
80104f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f76:	5b                   	pop    %ebx
80104f77:	5e                   	pop    %esi
80104f78:	5d                   	pop    %ebp
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	eb ec                	jmp    80104f73 <sys_fstat+0x53>
80104f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <sys_link>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f98:	53                   	push   %ebx
80104f99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f9c:	50                   	push   %eax
80104f9d:	6a 00                	push   $0x0
80104f9f:	e8 0c fb ff ff       	call   80104ab0 <argstr>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	0f 88 fb 00 00 00    	js     801050aa <sys_link+0x11a>
80104faf:	83 ec 08             	sub    $0x8,%esp
80104fb2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fb5:	50                   	push   %eax
80104fb6:	6a 01                	push   $0x1
80104fb8:	e8 f3 fa ff ff       	call   80104ab0 <argstr>
80104fbd:	83 c4 10             	add    $0x10,%esp
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	0f 88 e2 00 00 00    	js     801050aa <sys_link+0x11a>
  begin_op();
80104fc8:	e8 a3 dd ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	ff 75 d4             	push   -0x2c(%ebp)
80104fd3:	e8 c8 d0 ff ff       	call   801020a0 <namei>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	89 c3                	mov    %eax,%ebx
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	0f 84 e4 00 00 00    	je     801050c9 <sys_link+0x139>
  ilock(ip);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	50                   	push   %eax
80104fe9:	e8 92 c7 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ff6:	0f 84 b5 00 00 00    	je     801050b1 <sys_link+0x121>
  iupdate(ip);
80104ffc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104fff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105004:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105007:	53                   	push   %ebx
80105008:	e8 c3 c6 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010500d:	89 1c 24             	mov    %ebx,(%esp)
80105010:	e8 4b c8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105015:	58                   	pop    %eax
80105016:	5a                   	pop    %edx
80105017:	57                   	push   %edi
80105018:	ff 75 d0             	push   -0x30(%ebp)
8010501b:	e8 a0 d0 ff ff       	call   801020c0 <nameiparent>
80105020:	83 c4 10             	add    $0x10,%esp
80105023:	89 c6                	mov    %eax,%esi
80105025:	85 c0                	test   %eax,%eax
80105027:	74 5b                	je     80105084 <sys_link+0xf4>
  ilock(dp);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 4e c7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105032:	8b 03                	mov    (%ebx),%eax
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	39 06                	cmp    %eax,(%esi)
80105039:	75 3d                	jne    80105078 <sys_link+0xe8>
8010503b:	83 ec 04             	sub    $0x4,%esp
8010503e:	ff 73 04             	push   0x4(%ebx)
80105041:	57                   	push   %edi
80105042:	56                   	push   %esi
80105043:	e8 98 cf ff ff       	call   80101fe0 <dirlink>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	78 29                	js     80105078 <sys_link+0xe8>
  iunlockput(dp);
8010504f:	83 ec 0c             	sub    $0xc,%esp
80105052:	56                   	push   %esi
80105053:	e8 b8 c9 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105058:	89 1c 24             	mov    %ebx,(%esp)
8010505b:	e8 50 c8 ff ff       	call   801018b0 <iput>
  end_op();
80105060:	e8 7b dd ff ff       	call   80102de0 <end_op>
  return 0;
80105065:	83 c4 10             	add    $0x10,%esp
80105068:	31 c0                	xor    %eax,%eax
}
8010506a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5f                   	pop    %edi
80105070:	5d                   	pop    %ebp
80105071:	c3                   	ret    
80105072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	56                   	push   %esi
8010507c:	e8 8f c9 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105081:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	53                   	push   %ebx
80105088:	e8 f3 c6 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010508d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105092:	89 1c 24             	mov    %ebx,(%esp)
80105095:	e8 36 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010509a:	89 1c 24             	mov    %ebx,(%esp)
8010509d:	e8 6e c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
801050a2:	e8 39 dd ff ff       	call   80102de0 <end_op>
  return -1;
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050af:	eb b9                	jmp    8010506a <sys_link+0xda>
    iunlockput(ip);
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	53                   	push   %ebx
801050b5:	e8 56 c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
801050ba:	e8 21 dd ff ff       	call   80102de0 <end_op>
    return -1;
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c7:	eb a1                	jmp    8010506a <sys_link+0xda>
    end_op();
801050c9:	e8 12 dd ff ff       	call   80102de0 <end_op>
    return -1;
801050ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d3:	eb 95                	jmp    8010506a <sys_link+0xda>
801050d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_unlink>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050e8:	53                   	push   %ebx
801050e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801050ec:	50                   	push   %eax
801050ed:	6a 00                	push   $0x0
801050ef:	e8 bc f9 ff ff       	call   80104ab0 <argstr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	0f 88 7a 01 00 00    	js     80105279 <sys_unlink+0x199>
  begin_op();
801050ff:	e8 6c dc ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105104:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	53                   	push   %ebx
8010510b:	ff 75 c0             	push   -0x40(%ebp)
8010510e:	e8 ad cf ff ff       	call   801020c0 <nameiparent>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105119:	85 c0                	test   %eax,%eax
8010511b:	0f 84 62 01 00 00    	je     80105283 <sys_unlink+0x1a3>
  ilock(dp);
80105121:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	57                   	push   %edi
80105128:	e8 53 c6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010512d:	58                   	pop    %eax
8010512e:	5a                   	pop    %edx
8010512f:	68 c0 7d 10 80       	push   $0x80107dc0
80105134:	53                   	push   %ebx
80105135:	e8 86 cb ff ff       	call   80101cc0 <namecmp>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	85 c0                	test   %eax,%eax
8010513f:	0f 84 fb 00 00 00    	je     80105240 <sys_unlink+0x160>
80105145:	83 ec 08             	sub    $0x8,%esp
80105148:	68 bf 7d 10 80       	push   $0x80107dbf
8010514d:	53                   	push   %ebx
8010514e:	e8 6d cb ff ff       	call   80101cc0 <namecmp>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	0f 84 e2 00 00 00    	je     80105240 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010515e:	83 ec 04             	sub    $0x4,%esp
80105161:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105164:	50                   	push   %eax
80105165:	53                   	push   %ebx
80105166:	57                   	push   %edi
80105167:	e8 74 cb ff ff       	call   80101ce0 <dirlookup>
8010516c:	83 c4 10             	add    $0x10,%esp
8010516f:	89 c3                	mov    %eax,%ebx
80105171:	85 c0                	test   %eax,%eax
80105173:	0f 84 c7 00 00 00    	je     80105240 <sys_unlink+0x160>
  ilock(ip);
80105179:	83 ec 0c             	sub    $0xc,%esp
8010517c:	50                   	push   %eax
8010517d:	e8 fe c5 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010518a:	0f 8e 1c 01 00 00    	jle    801052ac <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105190:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105195:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105198:	74 66                	je     80105200 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010519a:	83 ec 04             	sub    $0x4,%esp
8010519d:	6a 10                	push   $0x10
8010519f:	6a 00                	push   $0x0
801051a1:	57                   	push   %edi
801051a2:	e8 89 f5 ff ff       	call   80104730 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051a7:	6a 10                	push   $0x10
801051a9:	ff 75 c4             	push   -0x3c(%ebp)
801051ac:	57                   	push   %edi
801051ad:	ff 75 b4             	push   -0x4c(%ebp)
801051b0:	e8 db c9 ff ff       	call   80101b90 <writei>
801051b5:	83 c4 20             	add    $0x20,%esp
801051b8:	83 f8 10             	cmp    $0x10,%eax
801051bb:	0f 85 de 00 00 00    	jne    8010529f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801051c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c6:	0f 84 94 00 00 00    	je     80105260 <sys_unlink+0x180>
  iunlockput(dp);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	ff 75 b4             	push   -0x4c(%ebp)
801051d2:	e8 39 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801051d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051dc:	89 1c 24             	mov    %ebx,(%esp)
801051df:	e8 ec c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051e4:	89 1c 24             	mov    %ebx,(%esp)
801051e7:	e8 24 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051ec:	e8 ef db ff ff       	call   80102de0 <end_op>
  return 0;
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	31 c0                	xor    %eax,%eax
}
801051f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051f9:	5b                   	pop    %ebx
801051fa:	5e                   	pop    %esi
801051fb:	5f                   	pop    %edi
801051fc:	5d                   	pop    %ebp
801051fd:	c3                   	ret    
801051fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105200:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105204:	76 94                	jbe    8010519a <sys_unlink+0xba>
80105206:	be 20 00 00 00       	mov    $0x20,%esi
8010520b:	eb 0b                	jmp    80105218 <sys_unlink+0x138>
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	83 c6 10             	add    $0x10,%esi
80105213:	3b 73 58             	cmp    0x58(%ebx),%esi
80105216:	73 82                	jae    8010519a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105218:	6a 10                	push   $0x10
8010521a:	56                   	push   %esi
8010521b:	57                   	push   %edi
8010521c:	53                   	push   %ebx
8010521d:	e8 6e c8 ff ff       	call   80101a90 <readi>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	83 f8 10             	cmp    $0x10,%eax
80105228:	75 68                	jne    80105292 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010522a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010522f:	74 df                	je     80105210 <sys_unlink+0x130>
    iunlockput(ip);
80105231:	83 ec 0c             	sub    $0xc,%esp
80105234:	53                   	push   %ebx
80105235:	e8 d6 c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	ff 75 b4             	push   -0x4c(%ebp)
80105246:	e8 c5 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010524b:	e8 90 db ff ff       	call   80102de0 <end_op>
  return -1;
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105258:	eb 9c                	jmp    801051f6 <sys_unlink+0x116>
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105260:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105263:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105266:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010526b:	50                   	push   %eax
8010526c:	e8 5f c4 ff ff       	call   801016d0 <iupdate>
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	e9 53 ff ff ff       	jmp    801051cc <sys_unlink+0xec>
    return -1;
80105279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527e:	e9 73 ff ff ff       	jmp    801051f6 <sys_unlink+0x116>
    end_op();
80105283:	e8 58 db ff ff       	call   80102de0 <end_op>
    return -1;
80105288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528d:	e9 64 ff ff ff       	jmp    801051f6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105292:	83 ec 0c             	sub    $0xc,%esp
80105295:	68 e4 7d 10 80       	push   $0x80107de4
8010529a:	e8 e1 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	68 f6 7d 10 80       	push   $0x80107df6
801052a7:	e8 d4 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	68 d2 7d 10 80       	push   $0x80107dd2
801052b4:	e8 c7 b0 ff ff       	call   80100380 <panic>
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_open>:

int
sys_open(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 dc f7 ff ff       	call   80104ab0 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 8e 00 00 00    	js     8010536d <sys_open+0xad>
801052df:	83 ec 08             	sub    $0x8,%esp
801052e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052e5:	50                   	push   %eax
801052e6:	6a 01                	push   $0x1
801052e8:	e8 03 f7 ff ff       	call   801049f0 <argint>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 79                	js     8010536d <sys_open+0xad>
    return -1;

  begin_op();
801052f4:	e8 77 da ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
801052f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052fd:	75 79                	jne    80105378 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052ff:	83 ec 0c             	sub    $0xc,%esp
80105302:	ff 75 e0             	push   -0x20(%ebp)
80105305:	e8 96 cd ff ff       	call   801020a0 <namei>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	89 c6                	mov    %eax,%esi
8010530f:	85 c0                	test   %eax,%eax
80105311:	0f 84 7e 00 00 00    	je     80105395 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	50                   	push   %eax
8010531b:	e8 60 c4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105328:	0f 84 c2 00 00 00    	je     801053f0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010532e:	e8 fd ba ff ff       	call   80100e30 <filealloc>
80105333:	89 c7                	mov    %eax,%edi
80105335:	85 c0                	test   %eax,%eax
80105337:	74 23                	je     8010535c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105339:	e8 42 e6 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010533e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105340:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105344:	85 d2                	test   %edx,%edx
80105346:	74 60                	je     801053a8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105348:	83 c3 01             	add    $0x1,%ebx
8010534b:	83 fb 10             	cmp    $0x10,%ebx
8010534e:	75 f0                	jne    80105340 <sys_open+0x80>
    if(f)
      fileclose(f);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	57                   	push   %edi
80105354:	e8 97 bb ff ff       	call   80100ef0 <fileclose>
80105359:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	56                   	push   %esi
80105360:	e8 ab c6 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105365:	e8 76 da ff ff       	call   80102de0 <end_op>
    return -1;
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105372:	eb 6d                	jmp    801053e1 <sys_open+0x121>
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010537e:	31 c9                	xor    %ecx,%ecx
80105380:	ba 02 00 00 00       	mov    $0x2,%edx
80105385:	6a 00                	push   $0x0
80105387:	e8 14 f8 ff ff       	call   80104ba0 <create>
    if(ip == 0){
8010538c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010538f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105391:	85 c0                	test   %eax,%eax
80105393:	75 99                	jne    8010532e <sys_open+0x6e>
      end_op();
80105395:	e8 46 da ff ff       	call   80102de0 <end_op>
      return -1;
8010539a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010539f:	eb 40                	jmp    801053e1 <sys_open+0x121>
801053a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053a8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053ab:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053af:	56                   	push   %esi
801053b0:	e8 ab c4 ff ff       	call   80101860 <iunlock>
  end_op();
801053b5:	e8 26 da ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
801053ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053c3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053c6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053c9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053cb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053d2:	f7 d0                	not    %eax
801053d4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053d7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053da:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e4:	89 d8                	mov    %ebx,%eax
801053e6:	5b                   	pop    %ebx
801053e7:	5e                   	pop    %esi
801053e8:	5f                   	pop    %edi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053f3:	85 c9                	test   %ecx,%ecx
801053f5:	0f 84 33 ff ff ff    	je     8010532e <sys_open+0x6e>
801053fb:	e9 5c ff ff ff       	jmp    8010535c <sys_open+0x9c>

80105400 <sys_mkdir>:

int
sys_mkdir(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105406:	e8 65 d9 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010540b:	83 ec 08             	sub    $0x8,%esp
8010540e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 97 f6 ff ff       	call   80104ab0 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 30                	js     80105450 <sys_mkdir+0x50>
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105426:	31 c9                	xor    %ecx,%ecx
80105428:	ba 01 00 00 00       	mov    $0x1,%edx
8010542d:	6a 00                	push   $0x0
8010542f:	e8 6c f7 ff ff       	call   80104ba0 <create>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	74 15                	je     80105450 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543b:	83 ec 0c             	sub    $0xc,%esp
8010543e:	50                   	push   %eax
8010543f:	e8 cc c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105444:	e8 97 d9 ff ff       	call   80102de0 <end_op>
  return 0;
80105449:	83 c4 10             	add    $0x10,%esp
8010544c:	31 c0                	xor    %eax,%eax
}
8010544e:	c9                   	leave  
8010544f:	c3                   	ret    
    end_op();
80105450:	e8 8b d9 ff ff       	call   80102de0 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_mknod>:

int
sys_mknod(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105466:	e8 05 d9 ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010546b:	83 ec 08             	sub    $0x8,%esp
8010546e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105471:	50                   	push   %eax
80105472:	6a 00                	push   $0x0
80105474:	e8 37 f6 ff ff       	call   80104ab0 <argstr>
80105479:	83 c4 10             	add    $0x10,%esp
8010547c:	85 c0                	test   %eax,%eax
8010547e:	78 60                	js     801054e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105480:	83 ec 08             	sub    $0x8,%esp
80105483:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105486:	50                   	push   %eax
80105487:	6a 01                	push   $0x1
80105489:	e8 62 f5 ff ff       	call   801049f0 <argint>
  if((argstr(0, &path)) < 0 ||
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	85 c0                	test   %eax,%eax
80105493:	78 4b                	js     801054e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105495:	83 ec 08             	sub    $0x8,%esp
80105498:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549b:	50                   	push   %eax
8010549c:	6a 02                	push   $0x2
8010549e:	e8 4d f5 ff ff       	call   801049f0 <argint>
     argint(1, &major) < 0 ||
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	78 36                	js     801054e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054b5:	ba 03 00 00 00       	mov    $0x3,%edx
801054ba:	50                   	push   %eax
801054bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054be:	e8 dd f6 ff ff       	call   80104ba0 <create>
     argint(2, &minor) < 0 ||
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 16                	je     801054e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ca:	83 ec 0c             	sub    $0xc,%esp
801054cd:	50                   	push   %eax
801054ce:	e8 3d c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
801054d3:	e8 08 d9 ff ff       	call   80102de0 <end_op>
  return 0;
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	31 c0                	xor    %eax,%eax
}
801054dd:	c9                   	leave  
801054de:	c3                   	ret    
801054df:	90                   	nop
    end_op();
801054e0:	e8 fb d8 ff ff       	call   80102de0 <end_op>
    return -1;
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ea:	c9                   	leave  
801054eb:	c3                   	ret    
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_chdir>:

int
sys_chdir(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054f8:	e8 83 e4 ff ff       	call   80103980 <myproc>
801054fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054ff:	e8 6c d8 ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105504:	83 ec 08             	sub    $0x8,%esp
80105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550a:	50                   	push   %eax
8010550b:	6a 00                	push   $0x0
8010550d:	e8 9e f5 ff ff       	call   80104ab0 <argstr>
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	85 c0                	test   %eax,%eax
80105517:	78 77                	js     80105590 <sys_chdir+0xa0>
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	ff 75 f4             	push   -0xc(%ebp)
8010551f:	e8 7c cb ff ff       	call   801020a0 <namei>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	89 c3                	mov    %eax,%ebx
80105529:	85 c0                	test   %eax,%eax
8010552b:	74 63                	je     80105590 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	50                   	push   %eax
80105531:	e8 4a c2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010553e:	75 30                	jne    80105570 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	53                   	push   %ebx
80105544:	e8 17 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105549:	58                   	pop    %eax
8010554a:	ff 76 68             	push   0x68(%esi)
8010554d:	e8 5e c3 ff ff       	call   801018b0 <iput>
  end_op();
80105552:	e8 89 d8 ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
80105557:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	31 c0                	xor    %eax,%eax
}
8010555f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5d                   	pop    %ebp
80105565:	c3                   	ret    
80105566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	53                   	push   %ebx
80105574:	e8 97 c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105579:	e8 62 d8 ff ff       	call   80102de0 <end_op>
    return -1;
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105586:	eb d7                	jmp    8010555f <sys_chdir+0x6f>
80105588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop
    end_op();
80105590:	e8 4b d8 ff ff       	call   80102de0 <end_op>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559a:	eb c3                	jmp    8010555f <sys_chdir+0x6f>
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_exec>:

int
sys_exec(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055ab:	53                   	push   %ebx
801055ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055b2:	50                   	push   %eax
801055b3:	6a 00                	push   $0x0
801055b5:	e8 f6 f4 ff ff       	call   80104ab0 <argstr>
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	85 c0                	test   %eax,%eax
801055bf:	0f 88 87 00 00 00    	js     8010564c <sys_exec+0xac>
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055ce:	50                   	push   %eax
801055cf:	6a 01                	push   $0x1
801055d1:	e8 1a f4 ff ff       	call   801049f0 <argint>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 6f                	js     8010564c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801055e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055e8:	68 80 00 00 00       	push   $0x80
801055ed:	6a 00                	push   $0x0
801055ef:	56                   	push   %esi
801055f0:	e8 3b f1 ff ff       	call   80104730 <memset>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105609:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105610:	50                   	push   %eax
80105611:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105617:	01 f8                	add    %edi,%eax
80105619:	50                   	push   %eax
8010561a:	e8 41 f3 ff ff       	call   80104960 <fetchint>
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	85 c0                	test   %eax,%eax
80105624:	78 26                	js     8010564c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105626:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010562c:	85 c0                	test   %eax,%eax
8010562e:	74 30                	je     80105660 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105636:	52                   	push   %edx
80105637:	50                   	push   %eax
80105638:	e8 63 f3 ff ff       	call   801049a0 <fetchstr>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 08                	js     8010564c <sys_exec+0xac>
  for(i=0;; i++){
80105644:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105647:	83 fb 20             	cmp    $0x20,%ebx
8010564a:	75 b4                	jne    80105600 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010564c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010564f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105654:	5b                   	pop    %ebx
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105660:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105667:	00 00 00 00 
  return exec(path, argv);
8010566b:	83 ec 08             	sub    $0x8,%esp
8010566e:	56                   	push   %esi
8010566f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105675:	e8 36 b4 ff ff       	call   80100ab0 <exec>
8010567a:	83 c4 10             	add    $0x10,%esp
}
8010567d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105680:	5b                   	pop    %ebx
80105681:	5e                   	pop    %esi
80105682:	5f                   	pop    %edi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret    
80105685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_pipe>:

int
sys_pipe(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105695:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105698:	53                   	push   %ebx
80105699:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010569c:	6a 08                	push   $0x8
8010569e:	50                   	push   %eax
8010569f:	6a 00                	push   $0x0
801056a1:	e8 9a f3 ff ff       	call   80104a40 <argptr>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	78 4a                	js     801056f7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056ad:	83 ec 08             	sub    $0x8,%esp
801056b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056b3:	50                   	push   %eax
801056b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056b7:	50                   	push   %eax
801056b8:	e8 83 dd ff ff       	call   80103440 <pipealloc>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 33                	js     801056f7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056c7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056c9:	e8 b2 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ce:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801056d0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056d4:	85 f6                	test   %esi,%esi
801056d6:	74 28                	je     80105700 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801056d8:	83 c3 01             	add    $0x1,%ebx
801056db:	83 fb 10             	cmp    $0x10,%ebx
801056de:	75 f0                	jne    801056d0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	ff 75 e0             	push   -0x20(%ebp)
801056e6:	e8 05 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801056eb:	58                   	pop    %eax
801056ec:	ff 75 e4             	push   -0x1c(%ebp)
801056ef:	e8 fc b7 ff ff       	call   80100ef0 <fileclose>
    return -1;
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fc:	eb 53                	jmp    80105751 <sys_pipe+0xc1>
801056fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105700:	8d 73 08             	lea    0x8(%ebx),%esi
80105703:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010570a:	e8 71 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010570f:	31 d2                	xor    %edx,%edx
80105711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105718:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010571c:	85 c9                	test   %ecx,%ecx
8010571e:	74 20                	je     80105740 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105720:	83 c2 01             	add    $0x1,%edx
80105723:	83 fa 10             	cmp    $0x10,%edx
80105726:	75 f0                	jne    80105718 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105728:	e8 53 e2 ff ff       	call   80103980 <myproc>
8010572d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105734:	00 
80105735:	eb a9                	jmp    801056e0 <sys_pipe+0x50>
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105740:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105744:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105747:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105749:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010574c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010574f:	31 c0                	xor    %eax,%eax
}
80105751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105754:	5b                   	pop    %ebx
80105755:	5e                   	pop    %esi
80105756:	5f                   	pop    %edi
80105757:	5d                   	pop    %ebp
80105758:	c3                   	ret    
80105759:	66 90                	xchg   %ax,%ax
8010575b:	66 90                	xchg   %ax,%ax
8010575d:	66 90                	xchg   %ax,%ax
8010575f:	90                   	nop

80105760 <sys_fork>:
#include "sysinfo.h"

int
sys_fork(void)
{
  return fork();
80105760:	e9 bb e3 ff ff       	jmp    80103b20 <fork>
80105765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exit>:
}

int
sys_exit(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  exit();
80105776:	e8 25 e6 ff ff       	call   80103da0 <exit>
  return 0;  // not reached
}
8010577b:	31 c0                	xor    %eax,%eax
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105780:	e9 4b e7 ff ff       	jmp    80103ed0 <wait>
80105785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_kill>:
}

int
sys_kill(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105796:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105799:	50                   	push   %eax
8010579a:	6a 00                	push   $0x0
8010579c:	e8 4f f2 ff ff       	call   801049f0 <argint>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	85 c0                	test   %eax,%eax
801057a6:	78 18                	js     801057c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	ff 75 f4             	push   -0xc(%ebp)
801057ae:	e8 bd e9 ff ff       	call   80104170 <kill>
801057b3:	83 c4 10             	add    $0x10,%esp
}
801057b6:	c9                   	leave  
801057b7:	c3                   	ret    
801057b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
801057c0:	c9                   	leave  
    return -1;
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c6:	c3                   	ret    
801057c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <sys_getpid>:

int
sys_getpid(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057d6:	e8 a5 e1 ff ff       	call   80103980 <myproc>
801057db:	8b 40 10             	mov    0x10(%eax),%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    

801057e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 fe f1 ff ff       	call   801049f0 <argint>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	78 27                	js     80105820 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057f9:	e8 82 e1 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801057fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105801:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105803:	ff 75 f4             	push   -0xc(%ebp)
80105806:	e8 95 e2 ff ff       	call   80103aa0 <growproc>
8010580b:	83 c4 10             	add    $0x10,%esp
8010580e:	85 c0                	test   %eax,%eax
80105810:	78 0e                	js     80105820 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105812:	89 d8                	mov    %ebx,%eax
80105814:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105817:	c9                   	leave  
80105818:	c3                   	ret    
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105820:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105825:	eb eb                	jmp    80105812 <sys_sbrk+0x32>
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_sleep>:

int
sys_sleep(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105837:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 ae f1 ff ff       	call   801049f0 <argint>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	0f 88 8a 00 00 00    	js     801058d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 80 4c 11 80       	push   $0x80114c80
80105855:	e8 16 ee ff ff       	call   80104670 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010585a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010585d:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  while(ticks - ticks0 < n){
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 d2                	test   %edx,%edx
80105868:	75 27                	jne    80105891 <sys_sleep+0x61>
8010586a:	eb 54                	jmp    801058c0 <sys_sleep+0x90>
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105870:	83 ec 08             	sub    $0x8,%esp
80105873:	68 80 4c 11 80       	push   $0x80114c80
80105878:	68 60 4c 11 80       	push   $0x80114c60
8010587d:	e8 ce e7 ff ff       	call   80104050 <sleep>
  while(ticks - ticks0 < n){
80105882:	a1 60 4c 11 80       	mov    0x80114c60,%eax
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	29 d8                	sub    %ebx,%eax
8010588c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010588f:	73 2f                	jae    801058c0 <sys_sleep+0x90>
    if(myproc()->killed){
80105891:	e8 ea e0 ff ff       	call   80103980 <myproc>
80105896:	8b 40 24             	mov    0x24(%eax),%eax
80105899:	85 c0                	test   %eax,%eax
8010589b:	74 d3                	je     80105870 <sys_sleep+0x40>
      release(&tickslock);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	68 80 4c 11 80       	push   $0x80114c80
801058a5:	e8 66 ed ff ff       	call   80104610 <release>
  }
  release(&tickslock);
  return 0;
}
801058aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	68 80 4c 11 80       	push   $0x80114c80
801058c8:	e8 43 ed ff ff       	call   80104610 <release>
  return 0;
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	31 c0                	xor    %eax,%eax
}
801058d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
    return -1;
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb f4                	jmp    801058d2 <sys_sleep+0xa2>
801058de:	66 90                	xchg   %ax,%ax

801058e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
801058e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058e7:	68 80 4c 11 80       	push   $0x80114c80
801058ec:	e8 7f ed ff ff       	call   80104670 <acquire>
  xticks = ticks;
801058f1:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  release(&tickslock);
801058f7:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
801058fe:	e8 0d ed ff ff       	call   80104610 <release>
  return xticks;
}
80105903:	89 d8                	mov    %ebx,%eax
80105905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105908:	c9                   	leave  
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105910 <sys_cps>:

int sys_cps(void){
return cps();
80105910:	e9 9b e9 ff ff       	jmp    801042b0 <cps>
80105915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_shm_alloc>:
}

int sys_shm_alloc(void) {
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	53                   	push   %ebx
	int size;
    if (argint(0, &size) < 0 || size <= 0)
80105924:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_shm_alloc(void) {
80105927:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &size) < 0 || size <= 0)
8010592a:	50                   	push   %eax
8010592b:	6a 00                	push   $0x0
8010592d:	e8 be f0 ff ff       	call   801049f0 <argint>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 2f                	js     80105968 <sys_shm_alloc+0x48>
80105939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593c:	85 c0                	test   %eax,%eax
8010593e:	7e 28                	jle    80105968 <sys_shm_alloc+0x48>
        return -1;  // Invalid size

    // Allocate memory using kalloc() (which is defined in kernel/kalloc.c)
    void *addr = kalloc();
80105940:	e8 4b cd ff ff       	call   80102690 <kalloc>
80105945:	89 c3                	mov    %eax,%ebx
    if (addr == 0)
80105947:	85 c0                	test   %eax,%eax
80105949:	74 1d                	je     80105968 <sys_shm_alloc+0x48>
        return -1;  // Memory allocation failed

    // Optionally clear the allocated memory
    memset(addr, 0, size);
8010594b:	83 ec 04             	sub    $0x4,%esp
8010594e:	ff 75 f4             	push   -0xc(%ebp)
80105951:	6a 00                	push   $0x0
80105953:	50                   	push   %eax
80105954:	e8 d7 ed ff ff       	call   80104730 <memset>

    // Return the allocated address as an integer (casting the pointer)
    return (int)(uint)addr;
80105959:	89 d8                	mov    %ebx,%eax
8010595b:	83 c4 10             	add    $0x10,%esp
   
}
8010595e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105961:	c9                   	leave  
80105962:	c3                   	ret    
80105963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105967:	90                   	nop
        return -1;  // Invalid size
80105968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596d:	eb ef                	jmp    8010595e <sys_shm_alloc+0x3e>
8010596f:	90                   	nop

80105970 <sys_describe>:

int 
sys_describe(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 14             	sub    $0x14,%esp
  cprintf("System Call Descriptions:\n\n");
80105976:	68 05 7e 10 80       	push   $0x80107e05
8010597b:	e8 20 ad ff ff       	call   801006a0 <cprintf>

    cprintf("1. fork():\n");
80105980:	c7 04 24 21 7e 10 80 	movl   $0x80107e21,(%esp)
80105987:	e8 14 ad ff ff       	call   801006a0 <cprintf>
    cprintf("   Creates a new process by duplicating the calling process.\n");
8010598c:	c7 04 24 d0 7f 10 80 	movl   $0x80107fd0,(%esp)
80105993:	e8 08 ad ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns 0 to the child process and the PID of the child to the parent.\n\n");
80105998:	c7 04 24 10 80 10 80 	movl   $0x80108010,(%esp)
8010599f:	e8 fc ac ff ff       	call   801006a0 <cprintf>

    cprintf("2. exec(path, argv):\n");
801059a4:	c7 04 24 2d 7e 10 80 	movl   $0x80107e2d,(%esp)
801059ab:	e8 f0 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Replaces the current process with a new process from the program at 'path'.\n");
801059b0:	c7 04 24 5c 80 10 80 	movl   $0x8010805c,(%esp)
801059b7:	e8 e4 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   'argv' is an array of arguments. Returns -1 on failure, does not return on success.\n\n");
801059bc:	c7 04 24 ac 80 10 80 	movl   $0x801080ac,(%esp)
801059c3:	e8 d8 ac ff ff       	call   801006a0 <cprintf>

    cprintf("3. wait():\n");
801059c8:	c7 04 24 43 7e 10 80 	movl   $0x80107e43,(%esp)
801059cf:	e8 cc ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Suspends execution until a child process terminates, then returns the child PID.\n");
801059d4:	c7 04 24 08 81 10 80 	movl   $0x80108108,(%esp)
801059db:	e8 c0 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns -1 if there are no children.\n\n");
801059e0:	c7 04 24 60 81 10 80 	movl   $0x80108160,(%esp)
801059e7:	e8 b4 ac ff ff       	call   801006a0 <cprintf>

    cprintf("4. kill(pid):\n");
801059ec:	c7 04 24 4f 7e 10 80 	movl   $0x80107e4f,(%esp)
801059f3:	e8 a8 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Sends a signal to terminate the process with the specified PID.\n");
801059f8:	c7 04 24 8c 81 10 80 	movl   $0x8010818c,(%esp)
801059ff:	e8 9c ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns 0 on success, or -1 if the PID is invalid.\n\n");
80105a04:	c7 04 24 d0 81 10 80 	movl   $0x801081d0,(%esp)
80105a0b:	e8 90 ac ff ff       	call   801006a0 <cprintf>

    cprintf("5. exit(status):\n");
80105a10:	c7 04 24 5e 7e 10 80 	movl   $0x80107e5e,(%esp)
80105a17:	e8 84 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Terminates the calling process with the specified status code.\n");
80105a1c:	c7 04 24 08 82 10 80 	movl   $0x80108208,(%esp)
80105a23:	e8 78 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Does not return.\n\n");
80105a28:	c7 04 24 70 7e 10 80 	movl   $0x80107e70,(%esp)
80105a2f:	e8 6c ac ff ff       	call   801006a0 <cprintf>

    cprintf("6. getpid():\n");
80105a34:	c7 04 24 86 7e 10 80 	movl   $0x80107e86,(%esp)
80105a3b:	e8 60 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns the process ID (PID) of the calling process.\n\n");
80105a40:	c7 04 24 4c 82 10 80 	movl   $0x8010824c,(%esp)
80105a47:	e8 54 ac ff ff       	call   801006a0 <cprintf>

    cprintf("7. sleep(seconds):\n");
80105a4c:	c7 04 24 94 7e 10 80 	movl   $0x80107e94,(%esp)
80105a53:	e8 48 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Suspends execution of the calling process for a specified time (in seconds).\n");
80105a58:	c7 04 24 88 82 10 80 	movl   $0x80108288,(%esp)
80105a5f:	e8 3c ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns 0 on success.\n\n");
80105a64:	c7 04 24 a8 7e 10 80 	movl   $0x80107ea8,(%esp)
80105a6b:	e8 30 ac ff ff       	call   801006a0 <cprintf>

    cprintf("8. uptime():\n");
80105a70:	c7 04 24 c3 7e 10 80 	movl   $0x80107ec3,(%esp)
80105a77:	e8 24 ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Returns the number of timer ticks since the system started.\n\n");
80105a7c:	c7 04 24 dc 82 10 80 	movl   $0x801082dc,(%esp)
80105a83:	e8 18 ac ff ff       	call   801006a0 <cprintf>

    cprintf("9. sbrk(n):\n");
80105a88:	c7 04 24 d1 7e 10 80 	movl   $0x80107ed1,(%esp)
80105a8f:	e8 0c ac ff ff       	call   801006a0 <cprintf>
    cprintf("   Increases the process’s data space by 'n' bytes. Returns the start address of the new area.\n\n");
80105a94:	c7 04 24 20 83 10 80 	movl   $0x80108320,(%esp)
80105a9b:	e8 00 ac ff ff       	call   801006a0 <cprintf>

    cprintf("10. open(filename, flags):\n");
80105aa0:	c7 04 24 de 7e 10 80 	movl   $0x80107ede,(%esp)
80105aa7:	e8 f4 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Opens the file specified by 'filename' with the given 'flags'.\n");
80105aac:	c7 04 24 84 83 10 80 	movl   $0x80108384,(%esp)
80105ab3:	e8 e8 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns a file descriptor, or -1 if the file could not be opened.\n\n");
80105ab8:	c7 04 24 c8 83 10 80 	movl   $0x801083c8,(%esp)
80105abf:	e8 dc ab ff ff       	call   801006a0 <cprintf>

    cprintf("11. read(fd, buffer, nbytes):\n");
80105ac4:	c7 04 24 10 84 10 80 	movl   $0x80108410,(%esp)
80105acb:	e8 d0 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Reads 'nbytes' from file descriptor 'fd' into 'buffer'.\n");
80105ad0:	c7 04 24 30 84 10 80 	movl   $0x80108430,(%esp)
80105ad7:	e8 c4 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns the number of bytes read, or -1 on error.\n\n");
80105adc:	c7 04 24 70 84 10 80 	movl   $0x80108470,(%esp)
80105ae3:	e8 b8 ab ff ff       	call   801006a0 <cprintf>

    cprintf("12. write(fd, buffer, nbytes):\n");
80105ae8:	c7 04 24 a8 84 10 80 	movl   $0x801084a8,(%esp)
80105aef:	e8 ac ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Writes 'nbytes' from 'buffer' to the file descriptor 'fd'.\n");
80105af4:	c7 04 24 c8 84 10 80 	movl   $0x801084c8,(%esp)
80105afb:	e8 a0 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns the number of bytes written, or -1 on error.\n\n");
80105b00:	c7 04 24 08 85 10 80 	movl   $0x80108508,(%esp)
80105b07:	e8 94 ab ff ff       	call   801006a0 <cprintf>

    cprintf("13. close(fd):\n");
80105b0c:	c7 04 24 fa 7e 10 80 	movl   $0x80107efa,(%esp)
80105b13:	e8 88 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Closes the file descriptor 'fd'.\n");
80105b18:	c7 04 24 44 85 10 80 	movl   $0x80108544,(%esp)
80105b1f:	e8 7c ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105b24:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105b2b:	e8 70 ab ff ff       	call   801006a0 <cprintf>

    cprintf("14. fstat(fd, stat):\n");
80105b30:	c7 04 24 0a 7f 10 80 	movl   $0x80107f0a,(%esp)
80105b37:	e8 64 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Retrieves file status information for the file descriptor 'fd' into 'stat'.\n");
80105b3c:	c7 04 24 98 85 10 80 	movl   $0x80108598,(%esp)
80105b43:	e8 58 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105b48:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105b4f:	e8 4c ab ff ff       	call   801006a0 <cprintf>

    cprintf("15. link(oldpath, newpath):\n");
80105b54:	c7 04 24 20 7f 10 80 	movl   $0x80107f20,(%esp)
80105b5b:	e8 40 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Creates a new link (newpath) to an existing file (oldpath).\n");
80105b60:	c7 04 24 ec 85 10 80 	movl   $0x801085ec,(%esp)
80105b67:	e8 34 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105b6c:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105b73:	e8 28 ab ff ff       	call   801006a0 <cprintf>

    cprintf("16. unlink(path):\n");
80105b78:	c7 04 24 3d 7f 10 80 	movl   $0x80107f3d,(%esp)
80105b7f:	e8 1c ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Removes the specified file (path) if it has no other links.\n");
80105b84:	c7 04 24 30 86 10 80 	movl   $0x80108630,(%esp)
80105b8b:	e8 10 ab ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105b90:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105b97:	e8 04 ab ff ff       	call   801006a0 <cprintf>

    cprintf("17. mkdir(path):\n");
80105b9c:	c7 04 24 50 7f 10 80 	movl   $0x80107f50,(%esp)
80105ba3:	e8 f8 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Creates a new directory at the specified path.\n");
80105ba8:	c7 04 24 74 86 10 80 	movl   $0x80108674,(%esp)
80105baf:	e8 ec aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105bb4:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105bbb:	e8 e0 aa ff ff       	call   801006a0 <cprintf>

    cprintf("18. chdir(path):\n");
80105bc0:	c7 04 24 62 7f 10 80 	movl   $0x80107f62,(%esp)
80105bc7:	e8 d4 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Changes the current working directory to the specified path.\n");
80105bcc:	c7 04 24 a8 86 10 80 	movl   $0x801086a8,(%esp)
80105bd3:	e8 c8 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105bd8:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105bdf:	e8 bc aa ff ff       	call   801006a0 <cprintf>

    cprintf("19. dup(fd):\n");
80105be4:	c7 04 24 74 7f 10 80 	movl   $0x80107f74,(%esp)
80105beb:	e8 b0 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Duplicates the file descriptor 'fd'.\n");
80105bf0:	c7 04 24 ec 86 10 80 	movl   $0x801086ec,(%esp)
80105bf7:	e8 a4 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns a new file descriptor pointing to the same file, or -1 on error.\n\n");
80105bfc:	c7 04 24 18 87 10 80 	movl   $0x80108718,(%esp)
80105c03:	e8 98 aa ff ff       	call   801006a0 <cprintf>

    cprintf("20. pipe(pipefd):\n");
80105c08:	c7 04 24 82 7f 10 80 	movl   $0x80107f82,(%esp)
80105c0f:	e8 8c aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Creates a pipe, a unidirectional data channel, and places the two ends of the pipe\n");
80105c14:	c7 04 24 68 87 10 80 	movl   $0x80108768,(%esp)
80105c1b:	e8 80 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    in the array 'pipefd'. Returns 0 on success, or -1 on error.\n\n");
80105c20:	c7 04 24 c0 87 10 80 	movl   $0x801087c0,(%esp)
80105c27:	e8 74 aa ff ff       	call   801006a0 <cprintf>

    cprintf("21. mknod(path, major, minor):\n");
80105c2c:	c7 04 24 04 88 10 80 	movl   $0x80108804,(%esp)
80105c33:	e8 68 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Creates a device file with the specified path, major number, and minor number.\n");
80105c38:	c7 04 24 24 88 10 80 	movl   $0x80108824,(%esp)
80105c3f:	e8 5c aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns 0 on success, or -1 on error.\n\n");
80105c44:	c7 04 24 6c 85 10 80 	movl   $0x8010856c,(%esp)
80105c4b:	e8 50 aa ff ff       	call   801006a0 <cprintf>

    cprintf("22. sendmsg(pid, message):\n");
80105c50:	c7 04 24 95 7f 10 80 	movl   $0x80107f95,(%esp)
80105c57:	e8 44 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Sends a message to the process with the specified PID.\n");
80105c5c:	c7 04 24 78 88 10 80 	movl   $0x80108878,(%esp)
80105c63:	e8 38 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    'message' is the content to be sent. Returns 0 on success, or -1 if the PID is invalid.\n\n");
80105c68:	c7 04 24 b4 88 10 80 	movl   $0x801088b4,(%esp)
80105c6f:	e8 2c aa ff ff       	call   801006a0 <cprintf>

    cprintf("23. recvmsg(buffer, maxlen):\n");
80105c74:	c7 04 24 b1 7f 10 80 	movl   $0x80107fb1,(%esp)
80105c7b:	e8 20 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Receives a message sent to the calling process and stores it in 'buffer'.\n");
80105c80:	c7 04 24 14 89 10 80 	movl   $0x80108914,(%esp)
80105c87:	e8 14 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    'maxlen' specifies the maximum number of characters to read.\n");
80105c8c:	c7 04 24 64 89 10 80 	movl   $0x80108964,(%esp)
80105c93:	e8 08 aa ff ff       	call   801006a0 <cprintf>
    cprintf("    Returns the number of bytes received, or -1 if no messages are available.\n\n");
80105c98:	c7 04 24 a8 89 10 80 	movl   $0x801089a8,(%esp)
80105c9f:	e8 fc a9 ff ff       	call   801006a0 <cprintf>

    cprintf("End of System Call Descriptions.\n");
80105ca4:	c7 04 24 f8 89 10 80 	movl   $0x801089f8,(%esp)
80105cab:	e8 f0 a9 ff ff       	call   801006a0 <cprintf>

    return 0;
}
80105cb0:	31 c0                	xor    %eax,%eax
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    

80105cb4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cb4:	1e                   	push   %ds
  pushl %es
80105cb5:	06                   	push   %es
  pushl %fs
80105cb6:	0f a0                	push   %fs
  pushl %gs
80105cb8:	0f a8                	push   %gs
  pushal
80105cba:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cbb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cbf:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cc1:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cc3:	54                   	push   %esp
  call trap
80105cc4:	e8 c7 00 00 00       	call   80105d90 <trap>
  addl $4, %esp
80105cc9:	83 c4 04             	add    $0x4,%esp

80105ccc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ccc:	61                   	popa   
  popl %gs
80105ccd:	0f a9                	pop    %gs
  popl %fs
80105ccf:	0f a1                	pop    %fs
  popl %es
80105cd1:	07                   	pop    %es
  popl %ds
80105cd2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cd3:	83 c4 08             	add    $0x8,%esp
  iret
80105cd6:	cf                   	iret   
80105cd7:	66 90                	xchg   %ax,%ax
80105cd9:	66 90                	xchg   %ax,%ax
80105cdb:	66 90                	xchg   %ax,%ax
80105cdd:	66 90                	xchg   %ax,%ax
80105cdf:	90                   	nop

80105ce0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ce0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ce1:	31 c0                	xor    %eax,%eax
{
80105ce3:	89 e5                	mov    %esp,%ebp
80105ce5:	83 ec 08             	sub    $0x8,%esp
80105ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105cf0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105cf7:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105cfe:	08 00 00 8e 
80105d02:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105d09:	80 
80105d0a:	c1 ea 10             	shr    $0x10,%edx
80105d0d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105d14:	80 
  for(i = 0; i < 256; i++)
80105d15:	83 c0 01             	add    $0x1,%eax
80105d18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d1d:	75 d1                	jne    80105cf0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d27:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105d2e:	00 00 ef 
  initlock(&tickslock, "time");
80105d31:	68 1a 8a 10 80       	push   $0x80108a1a
80105d36:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d3b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105d41:	c1 e8 10             	shr    $0x10,%eax
80105d44:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105d4a:	e8 51 e7 ff ff       	call   801044a0 <initlock>
}
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	c9                   	leave  
80105d53:	c3                   	ret    
80105d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop

80105d60 <idtinit>:

void
idtinit(void)
{
80105d60:	55                   	push   %ebp
  pd[0] = size-1;
80105d61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d66:	89 e5                	mov    %esp,%ebp
80105d68:	83 ec 10             	sub    $0x10,%esp
80105d6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d6f:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105d74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d78:	c1 e8 10             	shr    $0x10,%eax
80105d7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	57                   	push   %edi
80105d94:	56                   	push   %esi
80105d95:	53                   	push   %ebx
80105d96:	83 ec 1c             	sub    $0x1c,%esp
80105d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d9f:	83 f8 40             	cmp    $0x40,%eax
80105da2:	0f 84 68 01 00 00    	je     80105f10 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105da8:	83 e8 20             	sub    $0x20,%eax
80105dab:	83 f8 1f             	cmp    $0x1f,%eax
80105dae:	0f 87 8c 00 00 00    	ja     80105e40 <trap+0xb0>
80105db4:	ff 24 85 c0 8a 10 80 	jmp    *-0x7fef7540(,%eax,4)
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105dc0:	e8 7b c4 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105dc5:	e8 56 cb ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dca:	e8 b1 db ff ff       	call   80103980 <myproc>
80105dcf:	85 c0                	test   %eax,%eax
80105dd1:	74 1d                	je     80105df0 <trap+0x60>
80105dd3:	e8 a8 db ff ff       	call   80103980 <myproc>
80105dd8:	8b 50 24             	mov    0x24(%eax),%edx
80105ddb:	85 d2                	test   %edx,%edx
80105ddd:	74 11                	je     80105df0 <trap+0x60>
80105ddf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105de3:	83 e0 03             	and    $0x3,%eax
80105de6:	66 83 f8 03          	cmp    $0x3,%ax
80105dea:	0f 84 e8 01 00 00    	je     80105fd8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105df0:	e8 8b db ff ff       	call   80103980 <myproc>
80105df5:	85 c0                	test   %eax,%eax
80105df7:	74 0f                	je     80105e08 <trap+0x78>
80105df9:	e8 82 db ff ff       	call   80103980 <myproc>
80105dfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e02:	0f 84 b8 00 00 00    	je     80105ec0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e08:	e8 73 db ff ff       	call   80103980 <myproc>
80105e0d:	85 c0                	test   %eax,%eax
80105e0f:	74 1d                	je     80105e2e <trap+0x9e>
80105e11:	e8 6a db ff ff       	call   80103980 <myproc>
80105e16:	8b 40 24             	mov    0x24(%eax),%eax
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	74 11                	je     80105e2e <trap+0x9e>
80105e1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e21:	83 e0 03             	and    $0x3,%eax
80105e24:	66 83 f8 03          	cmp    $0x3,%ax
80105e28:	0f 84 0f 01 00 00    	je     80105f3d <trap+0x1ad>
    exit();
}
80105e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e31:	5b                   	pop    %ebx
80105e32:	5e                   	pop    %esi
80105e33:	5f                   	pop    %edi
80105e34:	5d                   	pop    %ebp
80105e35:	c3                   	ret    
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e40:	e8 3b db ff ff       	call   80103980 <myproc>
80105e45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	0f 84 a2 01 00 00    	je     80105ff2 <trap+0x262>
80105e50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e54:	0f 84 98 01 00 00    	je     80105ff2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e5a:	0f 20 d1             	mov    %cr2,%ecx
80105e5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e60:	e8 fb da ff ff       	call   80103960 <cpuid>
80105e65:	8b 73 30             	mov    0x30(%ebx),%esi
80105e68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105e6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105e71:	e8 0a db ff ff       	call   80103980 <myproc>
80105e76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e79:	e8 02 db ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e84:	51                   	push   %ecx
80105e85:	57                   	push   %edi
80105e86:	52                   	push   %edx
80105e87:	ff 75 e4             	push   -0x1c(%ebp)
80105e8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105e8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e91:	56                   	push   %esi
80105e92:	ff 70 10             	push   0x10(%eax)
80105e95:	68 7c 8a 10 80       	push   $0x80108a7c
80105e9a:	e8 01 a8 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105e9f:	83 c4 20             	add    $0x20,%esp
80105ea2:	e8 d9 da ff ff       	call   80103980 <myproc>
80105ea7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eae:	e8 cd da ff ff       	call   80103980 <myproc>
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	0f 85 18 ff ff ff    	jne    80105dd3 <trap+0x43>
80105ebb:	e9 30 ff ff ff       	jmp    80105df0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ec0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ec4:	0f 85 3e ff ff ff    	jne    80105e08 <trap+0x78>
    yield();
80105eca:	e8 31 e1 ff ff       	call   80104000 <yield>
80105ecf:	e9 34 ff ff ff       	jmp    80105e08 <trap+0x78>
80105ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ed8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105edb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105edf:	e8 7c da ff ff       	call   80103960 <cpuid>
80105ee4:	57                   	push   %edi
80105ee5:	56                   	push   %esi
80105ee6:	50                   	push   %eax
80105ee7:	68 24 8a 10 80       	push   $0x80108a24
80105eec:	e8 af a7 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ef1:	e8 2a ca ff ff       	call   80102920 <lapiceoi>
    break;
80105ef6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef9:	e8 82 da ff ff       	call   80103980 <myproc>
80105efe:	85 c0                	test   %eax,%eax
80105f00:	0f 85 cd fe ff ff    	jne    80105dd3 <trap+0x43>
80105f06:	e9 e5 fe ff ff       	jmp    80105df0 <trap+0x60>
80105f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f0f:	90                   	nop
    if(myproc()->killed)
80105f10:	e8 6b da ff ff       	call   80103980 <myproc>
80105f15:	8b 70 24             	mov    0x24(%eax),%esi
80105f18:	85 f6                	test   %esi,%esi
80105f1a:	0f 85 c8 00 00 00    	jne    80105fe8 <trap+0x258>
    myproc()->tf = tf;
80105f20:	e8 5b da ff ff       	call   80103980 <myproc>
80105f25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f28:	e8 03 ec ff ff       	call   80104b30 <syscall>
    if(myproc()->killed)
80105f2d:	e8 4e da ff ff       	call   80103980 <myproc>
80105f32:	8b 48 24             	mov    0x24(%eax),%ecx
80105f35:	85 c9                	test   %ecx,%ecx
80105f37:	0f 84 f1 fe ff ff    	je     80105e2e <trap+0x9e>
}
80105f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f40:	5b                   	pop    %ebx
80105f41:	5e                   	pop    %esi
80105f42:	5f                   	pop    %edi
80105f43:	5d                   	pop    %ebp
      exit();
80105f44:	e9 57 de ff ff       	jmp    80103da0 <exit>
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f50:	e8 3b 02 00 00       	call   80106190 <uartintr>
    lapiceoi();
80105f55:	e8 c6 c9 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f5a:	e8 21 da ff ff       	call   80103980 <myproc>
80105f5f:	85 c0                	test   %eax,%eax
80105f61:	0f 85 6c fe ff ff    	jne    80105dd3 <trap+0x43>
80105f67:	e9 84 fe ff ff       	jmp    80105df0 <trap+0x60>
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f70:	e8 6b c8 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
80105f75:	e8 a6 c9 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f7a:	e8 01 da ff ff       	call   80103980 <myproc>
80105f7f:	85 c0                	test   %eax,%eax
80105f81:	0f 85 4c fe ff ff    	jne    80105dd3 <trap+0x43>
80105f87:	e9 64 fe ff ff       	jmp    80105df0 <trap+0x60>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f90:	e8 cb d9 ff ff       	call   80103960 <cpuid>
80105f95:	85 c0                	test   %eax,%eax
80105f97:	0f 85 28 fe ff ff    	jne    80105dc5 <trap+0x35>
      acquire(&tickslock);
80105f9d:	83 ec 0c             	sub    $0xc,%esp
80105fa0:	68 80 4c 11 80       	push   $0x80114c80
80105fa5:	e8 c6 e6 ff ff       	call   80104670 <acquire>
      wakeup(&ticks);
80105faa:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
      ticks++;
80105fb1:	83 05 60 4c 11 80 01 	addl   $0x1,0x80114c60
      wakeup(&ticks);
80105fb8:	e8 53 e1 ff ff       	call   80104110 <wakeup>
      release(&tickslock);
80105fbd:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105fc4:	e8 47 e6 ff ff       	call   80104610 <release>
80105fc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105fcc:	e9 f4 fd ff ff       	jmp    80105dc5 <trap+0x35>
80105fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105fd8:	e8 c3 dd ff ff       	call   80103da0 <exit>
80105fdd:	e9 0e fe ff ff       	jmp    80105df0 <trap+0x60>
80105fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105fe8:	e8 b3 dd ff ff       	call   80103da0 <exit>
80105fed:	e9 2e ff ff ff       	jmp    80105f20 <trap+0x190>
80105ff2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ff5:	e8 66 d9 ff ff       	call   80103960 <cpuid>
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	56                   	push   %esi
80105ffe:	57                   	push   %edi
80105fff:	50                   	push   %eax
80106000:	ff 73 30             	push   0x30(%ebx)
80106003:	68 48 8a 10 80       	push   $0x80108a48
80106008:	e8 93 a6 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010600d:	83 c4 14             	add    $0x14,%esp
80106010:	68 1f 8a 10 80       	push   $0x80108a1f
80106015:	e8 66 a3 ff ff       	call   80100380 <panic>
8010601a:	66 90                	xchg   %ax,%ax
8010601c:	66 90                	xchg   %ax,%ax
8010601e:	66 90                	xchg   %ax,%ax

80106020 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106020:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106025:	85 c0                	test   %eax,%eax
80106027:	74 17                	je     80106040 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106029:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010602e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010602f:	a8 01                	test   $0x1,%al
80106031:	74 0d                	je     80106040 <uartgetc+0x20>
80106033:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106038:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106039:	0f b6 c0             	movzbl %al,%eax
8010603c:	c3                   	ret    
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106045:	c3                   	ret    
80106046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604d:	8d 76 00             	lea    0x0(%esi),%esi

80106050 <uartinit>:
{
80106050:	55                   	push   %ebp
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106051:	31 c9                	xor    %ecx,%ecx
80106053:	89 c8                	mov    %ecx,%eax
80106055:	89 e5                	mov    %esp,%ebp
80106057:	57                   	push   %edi
80106058:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010605d:	56                   	push   %esi
8010605e:	89 fa                	mov    %edi,%edx
80106060:	53                   	push   %ebx
80106061:	83 ec 1c             	sub    $0x1c,%esp
80106064:	ee                   	out    %al,(%dx)
80106065:	be fb 03 00 00       	mov    $0x3fb,%esi
8010606a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010606f:	89 f2                	mov    %esi,%edx
80106071:	ee                   	out    %al,(%dx)
80106072:	b8 0c 00 00 00       	mov    $0xc,%eax
80106077:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607c:	ee                   	out    %al,(%dx)
8010607d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106082:	89 c8                	mov    %ecx,%eax
80106084:	89 da                	mov    %ebx,%edx
80106086:	ee                   	out    %al,(%dx)
80106087:	b8 03 00 00 00       	mov    $0x3,%eax
8010608c:	89 f2                	mov    %esi,%edx
8010608e:	ee                   	out    %al,(%dx)
8010608f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106094:	89 c8                	mov    %ecx,%eax
80106096:	ee                   	out    %al,(%dx)
80106097:	b8 01 00 00 00       	mov    $0x1,%eax
8010609c:	89 da                	mov    %ebx,%edx
8010609e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010609f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060a5:	3c ff                	cmp    $0xff,%al
801060a7:	74 78                	je     80106121 <uartinit+0xd1>
  uart = 1;
801060a9:	c7 05 c0 54 11 80 01 	movl   $0x1,0x801154c0
801060b0:	00 00 00 
801060b3:	89 fa                	mov    %edi,%edx
801060b5:	ec                   	in     (%dx),%al
801060b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060bb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060bc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060bf:	bf 40 8b 10 80       	mov    $0x80108b40,%edi
801060c4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801060c9:	6a 00                	push   $0x0
801060cb:	6a 04                	push   $0x4
801060cd:	e8 ae c3 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801060d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801060e0:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801060e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801060ea:	85 c0                	test   %eax,%eax
801060ec:	75 14                	jne    80106102 <uartinit+0xb2>
801060ee:	eb 23                	jmp    80106113 <uartinit+0xc3>
    microdelay(10);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	6a 0a                	push   $0xa
801060f5:	e8 46 c8 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	83 eb 01             	sub    $0x1,%ebx
80106100:	74 07                	je     80106109 <uartinit+0xb9>
80106102:	89 f2                	mov    %esi,%edx
80106104:	ec                   	in     (%dx),%al
80106105:	a8 20                	test   $0x20,%al
80106107:	74 e7                	je     801060f0 <uartinit+0xa0>
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106109:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010610d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106112:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106113:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106117:	83 c7 01             	add    $0x1,%edi
8010611a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010611d:	84 c0                	test   %al,%al
8010611f:	75 bf                	jne    801060e0 <uartinit+0x90>
}
80106121:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106124:	5b                   	pop    %ebx
80106125:	5e                   	pop    %esi
80106126:	5f                   	pop    %edi
80106127:	5d                   	pop    %ebp
80106128:	c3                   	ret    
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106130 <uartputc>:
  if(!uart)
80106130:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106135:	85 c0                	test   %eax,%eax
80106137:	74 47                	je     80106180 <uartputc+0x50>
{
80106139:	55                   	push   %ebp
8010613a:	89 e5                	mov    %esp,%ebp
8010613c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010613d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106142:	53                   	push   %ebx
80106143:	bb 80 00 00 00       	mov    $0x80,%ebx
80106148:	eb 18                	jmp    80106162 <uartputc+0x32>
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	6a 0a                	push   $0xa
80106155:	e8 e6 c7 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010615a:	83 c4 10             	add    $0x10,%esp
8010615d:	83 eb 01             	sub    $0x1,%ebx
80106160:	74 07                	je     80106169 <uartputc+0x39>
80106162:	89 f2                	mov    %esi,%edx
80106164:	ec                   	in     (%dx),%al
80106165:	a8 20                	test   $0x20,%al
80106167:	74 e7                	je     80106150 <uartputc+0x20>
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106169:	8b 45 08             	mov    0x8(%ebp),%eax
8010616c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106171:	ee                   	out    %al,(%dx)
}
80106172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106175:	5b                   	pop    %ebx
80106176:	5e                   	pop    %esi
80106177:	5d                   	pop    %ebp
80106178:	c3                   	ret    
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106180:	c3                   	ret    
80106181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop

80106190 <uartintr>:

void
uartintr(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106196:	68 20 60 10 80       	push   $0x80106020
8010619b:	e8 e0 a6 ff ff       	call   80100880 <consoleintr>
}
801061a0:	83 c4 10             	add    $0x10,%esp
801061a3:	c9                   	leave  
801061a4:	c3                   	ret    

801061a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $0
801061a7:	6a 00                	push   $0x0
  jmp alltraps
801061a9:	e9 06 fb ff ff       	jmp    80105cb4 <alltraps>

801061ae <vector1>:
.globl vector1
vector1:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $1
801061b0:	6a 01                	push   $0x1
  jmp alltraps
801061b2:	e9 fd fa ff ff       	jmp    80105cb4 <alltraps>

801061b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $2
801061b9:	6a 02                	push   $0x2
  jmp alltraps
801061bb:	e9 f4 fa ff ff       	jmp    80105cb4 <alltraps>

801061c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $3
801061c2:	6a 03                	push   $0x3
  jmp alltraps
801061c4:	e9 eb fa ff ff       	jmp    80105cb4 <alltraps>

801061c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $4
801061cb:	6a 04                	push   $0x4
  jmp alltraps
801061cd:	e9 e2 fa ff ff       	jmp    80105cb4 <alltraps>

801061d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $5
801061d4:	6a 05                	push   $0x5
  jmp alltraps
801061d6:	e9 d9 fa ff ff       	jmp    80105cb4 <alltraps>

801061db <vector6>:
.globl vector6
vector6:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $6
801061dd:	6a 06                	push   $0x6
  jmp alltraps
801061df:	e9 d0 fa ff ff       	jmp    80105cb4 <alltraps>

801061e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $7
801061e6:	6a 07                	push   $0x7
  jmp alltraps
801061e8:	e9 c7 fa ff ff       	jmp    80105cb4 <alltraps>

801061ed <vector8>:
.globl vector8
vector8:
  pushl $8
801061ed:	6a 08                	push   $0x8
  jmp alltraps
801061ef:	e9 c0 fa ff ff       	jmp    80105cb4 <alltraps>

801061f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $9
801061f6:	6a 09                	push   $0x9
  jmp alltraps
801061f8:	e9 b7 fa ff ff       	jmp    80105cb4 <alltraps>

801061fd <vector10>:
.globl vector10
vector10:
  pushl $10
801061fd:	6a 0a                	push   $0xa
  jmp alltraps
801061ff:	e9 b0 fa ff ff       	jmp    80105cb4 <alltraps>

80106204 <vector11>:
.globl vector11
vector11:
  pushl $11
80106204:	6a 0b                	push   $0xb
  jmp alltraps
80106206:	e9 a9 fa ff ff       	jmp    80105cb4 <alltraps>

8010620b <vector12>:
.globl vector12
vector12:
  pushl $12
8010620b:	6a 0c                	push   $0xc
  jmp alltraps
8010620d:	e9 a2 fa ff ff       	jmp    80105cb4 <alltraps>

80106212 <vector13>:
.globl vector13
vector13:
  pushl $13
80106212:	6a 0d                	push   $0xd
  jmp alltraps
80106214:	e9 9b fa ff ff       	jmp    80105cb4 <alltraps>

80106219 <vector14>:
.globl vector14
vector14:
  pushl $14
80106219:	6a 0e                	push   $0xe
  jmp alltraps
8010621b:	e9 94 fa ff ff       	jmp    80105cb4 <alltraps>

80106220 <vector15>:
.globl vector15
vector15:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $15
80106222:	6a 0f                	push   $0xf
  jmp alltraps
80106224:	e9 8b fa ff ff       	jmp    80105cb4 <alltraps>

80106229 <vector16>:
.globl vector16
vector16:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $16
8010622b:	6a 10                	push   $0x10
  jmp alltraps
8010622d:	e9 82 fa ff ff       	jmp    80105cb4 <alltraps>

80106232 <vector17>:
.globl vector17
vector17:
  pushl $17
80106232:	6a 11                	push   $0x11
  jmp alltraps
80106234:	e9 7b fa ff ff       	jmp    80105cb4 <alltraps>

80106239 <vector18>:
.globl vector18
vector18:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $18
8010623b:	6a 12                	push   $0x12
  jmp alltraps
8010623d:	e9 72 fa ff ff       	jmp    80105cb4 <alltraps>

80106242 <vector19>:
.globl vector19
vector19:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $19
80106244:	6a 13                	push   $0x13
  jmp alltraps
80106246:	e9 69 fa ff ff       	jmp    80105cb4 <alltraps>

8010624b <vector20>:
.globl vector20
vector20:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $20
8010624d:	6a 14                	push   $0x14
  jmp alltraps
8010624f:	e9 60 fa ff ff       	jmp    80105cb4 <alltraps>

80106254 <vector21>:
.globl vector21
vector21:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $21
80106256:	6a 15                	push   $0x15
  jmp alltraps
80106258:	e9 57 fa ff ff       	jmp    80105cb4 <alltraps>

8010625d <vector22>:
.globl vector22
vector22:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $22
8010625f:	6a 16                	push   $0x16
  jmp alltraps
80106261:	e9 4e fa ff ff       	jmp    80105cb4 <alltraps>

80106266 <vector23>:
.globl vector23
vector23:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $23
80106268:	6a 17                	push   $0x17
  jmp alltraps
8010626a:	e9 45 fa ff ff       	jmp    80105cb4 <alltraps>

8010626f <vector24>:
.globl vector24
vector24:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $24
80106271:	6a 18                	push   $0x18
  jmp alltraps
80106273:	e9 3c fa ff ff       	jmp    80105cb4 <alltraps>

80106278 <vector25>:
.globl vector25
vector25:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $25
8010627a:	6a 19                	push   $0x19
  jmp alltraps
8010627c:	e9 33 fa ff ff       	jmp    80105cb4 <alltraps>

80106281 <vector26>:
.globl vector26
vector26:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $26
80106283:	6a 1a                	push   $0x1a
  jmp alltraps
80106285:	e9 2a fa ff ff       	jmp    80105cb4 <alltraps>

8010628a <vector27>:
.globl vector27
vector27:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $27
8010628c:	6a 1b                	push   $0x1b
  jmp alltraps
8010628e:	e9 21 fa ff ff       	jmp    80105cb4 <alltraps>

80106293 <vector28>:
.globl vector28
vector28:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $28
80106295:	6a 1c                	push   $0x1c
  jmp alltraps
80106297:	e9 18 fa ff ff       	jmp    80105cb4 <alltraps>

8010629c <vector29>:
.globl vector29
vector29:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $29
8010629e:	6a 1d                	push   $0x1d
  jmp alltraps
801062a0:	e9 0f fa ff ff       	jmp    80105cb4 <alltraps>

801062a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $30
801062a7:	6a 1e                	push   $0x1e
  jmp alltraps
801062a9:	e9 06 fa ff ff       	jmp    80105cb4 <alltraps>

801062ae <vector31>:
.globl vector31
vector31:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $31
801062b0:	6a 1f                	push   $0x1f
  jmp alltraps
801062b2:	e9 fd f9 ff ff       	jmp    80105cb4 <alltraps>

801062b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $32
801062b9:	6a 20                	push   $0x20
  jmp alltraps
801062bb:	e9 f4 f9 ff ff       	jmp    80105cb4 <alltraps>

801062c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $33
801062c2:	6a 21                	push   $0x21
  jmp alltraps
801062c4:	e9 eb f9 ff ff       	jmp    80105cb4 <alltraps>

801062c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $34
801062cb:	6a 22                	push   $0x22
  jmp alltraps
801062cd:	e9 e2 f9 ff ff       	jmp    80105cb4 <alltraps>

801062d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $35
801062d4:	6a 23                	push   $0x23
  jmp alltraps
801062d6:	e9 d9 f9 ff ff       	jmp    80105cb4 <alltraps>

801062db <vector36>:
.globl vector36
vector36:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $36
801062dd:	6a 24                	push   $0x24
  jmp alltraps
801062df:	e9 d0 f9 ff ff       	jmp    80105cb4 <alltraps>

801062e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $37
801062e6:	6a 25                	push   $0x25
  jmp alltraps
801062e8:	e9 c7 f9 ff ff       	jmp    80105cb4 <alltraps>

801062ed <vector38>:
.globl vector38
vector38:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $38
801062ef:	6a 26                	push   $0x26
  jmp alltraps
801062f1:	e9 be f9 ff ff       	jmp    80105cb4 <alltraps>

801062f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $39
801062f8:	6a 27                	push   $0x27
  jmp alltraps
801062fa:	e9 b5 f9 ff ff       	jmp    80105cb4 <alltraps>

801062ff <vector40>:
.globl vector40
vector40:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $40
80106301:	6a 28                	push   $0x28
  jmp alltraps
80106303:	e9 ac f9 ff ff       	jmp    80105cb4 <alltraps>

80106308 <vector41>:
.globl vector41
vector41:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $41
8010630a:	6a 29                	push   $0x29
  jmp alltraps
8010630c:	e9 a3 f9 ff ff       	jmp    80105cb4 <alltraps>

80106311 <vector42>:
.globl vector42
vector42:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $42
80106313:	6a 2a                	push   $0x2a
  jmp alltraps
80106315:	e9 9a f9 ff ff       	jmp    80105cb4 <alltraps>

8010631a <vector43>:
.globl vector43
vector43:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $43
8010631c:	6a 2b                	push   $0x2b
  jmp alltraps
8010631e:	e9 91 f9 ff ff       	jmp    80105cb4 <alltraps>

80106323 <vector44>:
.globl vector44
vector44:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $44
80106325:	6a 2c                	push   $0x2c
  jmp alltraps
80106327:	e9 88 f9 ff ff       	jmp    80105cb4 <alltraps>

8010632c <vector45>:
.globl vector45
vector45:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $45
8010632e:	6a 2d                	push   $0x2d
  jmp alltraps
80106330:	e9 7f f9 ff ff       	jmp    80105cb4 <alltraps>

80106335 <vector46>:
.globl vector46
vector46:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $46
80106337:	6a 2e                	push   $0x2e
  jmp alltraps
80106339:	e9 76 f9 ff ff       	jmp    80105cb4 <alltraps>

8010633e <vector47>:
.globl vector47
vector47:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $47
80106340:	6a 2f                	push   $0x2f
  jmp alltraps
80106342:	e9 6d f9 ff ff       	jmp    80105cb4 <alltraps>

80106347 <vector48>:
.globl vector48
vector48:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $48
80106349:	6a 30                	push   $0x30
  jmp alltraps
8010634b:	e9 64 f9 ff ff       	jmp    80105cb4 <alltraps>

80106350 <vector49>:
.globl vector49
vector49:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $49
80106352:	6a 31                	push   $0x31
  jmp alltraps
80106354:	e9 5b f9 ff ff       	jmp    80105cb4 <alltraps>

80106359 <vector50>:
.globl vector50
vector50:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $50
8010635b:	6a 32                	push   $0x32
  jmp alltraps
8010635d:	e9 52 f9 ff ff       	jmp    80105cb4 <alltraps>

80106362 <vector51>:
.globl vector51
vector51:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $51
80106364:	6a 33                	push   $0x33
  jmp alltraps
80106366:	e9 49 f9 ff ff       	jmp    80105cb4 <alltraps>

8010636b <vector52>:
.globl vector52
vector52:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $52
8010636d:	6a 34                	push   $0x34
  jmp alltraps
8010636f:	e9 40 f9 ff ff       	jmp    80105cb4 <alltraps>

80106374 <vector53>:
.globl vector53
vector53:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $53
80106376:	6a 35                	push   $0x35
  jmp alltraps
80106378:	e9 37 f9 ff ff       	jmp    80105cb4 <alltraps>

8010637d <vector54>:
.globl vector54
vector54:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $54
8010637f:	6a 36                	push   $0x36
  jmp alltraps
80106381:	e9 2e f9 ff ff       	jmp    80105cb4 <alltraps>

80106386 <vector55>:
.globl vector55
vector55:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $55
80106388:	6a 37                	push   $0x37
  jmp alltraps
8010638a:	e9 25 f9 ff ff       	jmp    80105cb4 <alltraps>

8010638f <vector56>:
.globl vector56
vector56:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $56
80106391:	6a 38                	push   $0x38
  jmp alltraps
80106393:	e9 1c f9 ff ff       	jmp    80105cb4 <alltraps>

80106398 <vector57>:
.globl vector57
vector57:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $57
8010639a:	6a 39                	push   $0x39
  jmp alltraps
8010639c:	e9 13 f9 ff ff       	jmp    80105cb4 <alltraps>

801063a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $58
801063a3:	6a 3a                	push   $0x3a
  jmp alltraps
801063a5:	e9 0a f9 ff ff       	jmp    80105cb4 <alltraps>

801063aa <vector59>:
.globl vector59
vector59:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $59
801063ac:	6a 3b                	push   $0x3b
  jmp alltraps
801063ae:	e9 01 f9 ff ff       	jmp    80105cb4 <alltraps>

801063b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $60
801063b5:	6a 3c                	push   $0x3c
  jmp alltraps
801063b7:	e9 f8 f8 ff ff       	jmp    80105cb4 <alltraps>

801063bc <vector61>:
.globl vector61
vector61:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $61
801063be:	6a 3d                	push   $0x3d
  jmp alltraps
801063c0:	e9 ef f8 ff ff       	jmp    80105cb4 <alltraps>

801063c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $62
801063c7:	6a 3e                	push   $0x3e
  jmp alltraps
801063c9:	e9 e6 f8 ff ff       	jmp    80105cb4 <alltraps>

801063ce <vector63>:
.globl vector63
vector63:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $63
801063d0:	6a 3f                	push   $0x3f
  jmp alltraps
801063d2:	e9 dd f8 ff ff       	jmp    80105cb4 <alltraps>

801063d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $64
801063d9:	6a 40                	push   $0x40
  jmp alltraps
801063db:	e9 d4 f8 ff ff       	jmp    80105cb4 <alltraps>

801063e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $65
801063e2:	6a 41                	push   $0x41
  jmp alltraps
801063e4:	e9 cb f8 ff ff       	jmp    80105cb4 <alltraps>

801063e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $66
801063eb:	6a 42                	push   $0x42
  jmp alltraps
801063ed:	e9 c2 f8 ff ff       	jmp    80105cb4 <alltraps>

801063f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $67
801063f4:	6a 43                	push   $0x43
  jmp alltraps
801063f6:	e9 b9 f8 ff ff       	jmp    80105cb4 <alltraps>

801063fb <vector68>:
.globl vector68
vector68:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $68
801063fd:	6a 44                	push   $0x44
  jmp alltraps
801063ff:	e9 b0 f8 ff ff       	jmp    80105cb4 <alltraps>

80106404 <vector69>:
.globl vector69
vector69:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $69
80106406:	6a 45                	push   $0x45
  jmp alltraps
80106408:	e9 a7 f8 ff ff       	jmp    80105cb4 <alltraps>

8010640d <vector70>:
.globl vector70
vector70:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $70
8010640f:	6a 46                	push   $0x46
  jmp alltraps
80106411:	e9 9e f8 ff ff       	jmp    80105cb4 <alltraps>

80106416 <vector71>:
.globl vector71
vector71:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $71
80106418:	6a 47                	push   $0x47
  jmp alltraps
8010641a:	e9 95 f8 ff ff       	jmp    80105cb4 <alltraps>

8010641f <vector72>:
.globl vector72
vector72:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $72
80106421:	6a 48                	push   $0x48
  jmp alltraps
80106423:	e9 8c f8 ff ff       	jmp    80105cb4 <alltraps>

80106428 <vector73>:
.globl vector73
vector73:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $73
8010642a:	6a 49                	push   $0x49
  jmp alltraps
8010642c:	e9 83 f8 ff ff       	jmp    80105cb4 <alltraps>

80106431 <vector74>:
.globl vector74
vector74:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $74
80106433:	6a 4a                	push   $0x4a
  jmp alltraps
80106435:	e9 7a f8 ff ff       	jmp    80105cb4 <alltraps>

8010643a <vector75>:
.globl vector75
vector75:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $75
8010643c:	6a 4b                	push   $0x4b
  jmp alltraps
8010643e:	e9 71 f8 ff ff       	jmp    80105cb4 <alltraps>

80106443 <vector76>:
.globl vector76
vector76:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $76
80106445:	6a 4c                	push   $0x4c
  jmp alltraps
80106447:	e9 68 f8 ff ff       	jmp    80105cb4 <alltraps>

8010644c <vector77>:
.globl vector77
vector77:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $77
8010644e:	6a 4d                	push   $0x4d
  jmp alltraps
80106450:	e9 5f f8 ff ff       	jmp    80105cb4 <alltraps>

80106455 <vector78>:
.globl vector78
vector78:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $78
80106457:	6a 4e                	push   $0x4e
  jmp alltraps
80106459:	e9 56 f8 ff ff       	jmp    80105cb4 <alltraps>

8010645e <vector79>:
.globl vector79
vector79:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $79
80106460:	6a 4f                	push   $0x4f
  jmp alltraps
80106462:	e9 4d f8 ff ff       	jmp    80105cb4 <alltraps>

80106467 <vector80>:
.globl vector80
vector80:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $80
80106469:	6a 50                	push   $0x50
  jmp alltraps
8010646b:	e9 44 f8 ff ff       	jmp    80105cb4 <alltraps>

80106470 <vector81>:
.globl vector81
vector81:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $81
80106472:	6a 51                	push   $0x51
  jmp alltraps
80106474:	e9 3b f8 ff ff       	jmp    80105cb4 <alltraps>

80106479 <vector82>:
.globl vector82
vector82:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $82
8010647b:	6a 52                	push   $0x52
  jmp alltraps
8010647d:	e9 32 f8 ff ff       	jmp    80105cb4 <alltraps>

80106482 <vector83>:
.globl vector83
vector83:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $83
80106484:	6a 53                	push   $0x53
  jmp alltraps
80106486:	e9 29 f8 ff ff       	jmp    80105cb4 <alltraps>

8010648b <vector84>:
.globl vector84
vector84:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $84
8010648d:	6a 54                	push   $0x54
  jmp alltraps
8010648f:	e9 20 f8 ff ff       	jmp    80105cb4 <alltraps>

80106494 <vector85>:
.globl vector85
vector85:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $85
80106496:	6a 55                	push   $0x55
  jmp alltraps
80106498:	e9 17 f8 ff ff       	jmp    80105cb4 <alltraps>

8010649d <vector86>:
.globl vector86
vector86:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $86
8010649f:	6a 56                	push   $0x56
  jmp alltraps
801064a1:	e9 0e f8 ff ff       	jmp    80105cb4 <alltraps>

801064a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $87
801064a8:	6a 57                	push   $0x57
  jmp alltraps
801064aa:	e9 05 f8 ff ff       	jmp    80105cb4 <alltraps>

801064af <vector88>:
.globl vector88
vector88:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $88
801064b1:	6a 58                	push   $0x58
  jmp alltraps
801064b3:	e9 fc f7 ff ff       	jmp    80105cb4 <alltraps>

801064b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $89
801064ba:	6a 59                	push   $0x59
  jmp alltraps
801064bc:	e9 f3 f7 ff ff       	jmp    80105cb4 <alltraps>

801064c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $90
801064c3:	6a 5a                	push   $0x5a
  jmp alltraps
801064c5:	e9 ea f7 ff ff       	jmp    80105cb4 <alltraps>

801064ca <vector91>:
.globl vector91
vector91:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $91
801064cc:	6a 5b                	push   $0x5b
  jmp alltraps
801064ce:	e9 e1 f7 ff ff       	jmp    80105cb4 <alltraps>

801064d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $92
801064d5:	6a 5c                	push   $0x5c
  jmp alltraps
801064d7:	e9 d8 f7 ff ff       	jmp    80105cb4 <alltraps>

801064dc <vector93>:
.globl vector93
vector93:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $93
801064de:	6a 5d                	push   $0x5d
  jmp alltraps
801064e0:	e9 cf f7 ff ff       	jmp    80105cb4 <alltraps>

801064e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $94
801064e7:	6a 5e                	push   $0x5e
  jmp alltraps
801064e9:	e9 c6 f7 ff ff       	jmp    80105cb4 <alltraps>

801064ee <vector95>:
.globl vector95
vector95:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $95
801064f0:	6a 5f                	push   $0x5f
  jmp alltraps
801064f2:	e9 bd f7 ff ff       	jmp    80105cb4 <alltraps>

801064f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $96
801064f9:	6a 60                	push   $0x60
  jmp alltraps
801064fb:	e9 b4 f7 ff ff       	jmp    80105cb4 <alltraps>

80106500 <vector97>:
.globl vector97
vector97:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $97
80106502:	6a 61                	push   $0x61
  jmp alltraps
80106504:	e9 ab f7 ff ff       	jmp    80105cb4 <alltraps>

80106509 <vector98>:
.globl vector98
vector98:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $98
8010650b:	6a 62                	push   $0x62
  jmp alltraps
8010650d:	e9 a2 f7 ff ff       	jmp    80105cb4 <alltraps>

80106512 <vector99>:
.globl vector99
vector99:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $99
80106514:	6a 63                	push   $0x63
  jmp alltraps
80106516:	e9 99 f7 ff ff       	jmp    80105cb4 <alltraps>

8010651b <vector100>:
.globl vector100
vector100:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $100
8010651d:	6a 64                	push   $0x64
  jmp alltraps
8010651f:	e9 90 f7 ff ff       	jmp    80105cb4 <alltraps>

80106524 <vector101>:
.globl vector101
vector101:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $101
80106526:	6a 65                	push   $0x65
  jmp alltraps
80106528:	e9 87 f7 ff ff       	jmp    80105cb4 <alltraps>

8010652d <vector102>:
.globl vector102
vector102:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $102
8010652f:	6a 66                	push   $0x66
  jmp alltraps
80106531:	e9 7e f7 ff ff       	jmp    80105cb4 <alltraps>

80106536 <vector103>:
.globl vector103
vector103:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $103
80106538:	6a 67                	push   $0x67
  jmp alltraps
8010653a:	e9 75 f7 ff ff       	jmp    80105cb4 <alltraps>

8010653f <vector104>:
.globl vector104
vector104:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $104
80106541:	6a 68                	push   $0x68
  jmp alltraps
80106543:	e9 6c f7 ff ff       	jmp    80105cb4 <alltraps>

80106548 <vector105>:
.globl vector105
vector105:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $105
8010654a:	6a 69                	push   $0x69
  jmp alltraps
8010654c:	e9 63 f7 ff ff       	jmp    80105cb4 <alltraps>

80106551 <vector106>:
.globl vector106
vector106:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $106
80106553:	6a 6a                	push   $0x6a
  jmp alltraps
80106555:	e9 5a f7 ff ff       	jmp    80105cb4 <alltraps>

8010655a <vector107>:
.globl vector107
vector107:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $107
8010655c:	6a 6b                	push   $0x6b
  jmp alltraps
8010655e:	e9 51 f7 ff ff       	jmp    80105cb4 <alltraps>

80106563 <vector108>:
.globl vector108
vector108:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $108
80106565:	6a 6c                	push   $0x6c
  jmp alltraps
80106567:	e9 48 f7 ff ff       	jmp    80105cb4 <alltraps>

8010656c <vector109>:
.globl vector109
vector109:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $109
8010656e:	6a 6d                	push   $0x6d
  jmp alltraps
80106570:	e9 3f f7 ff ff       	jmp    80105cb4 <alltraps>

80106575 <vector110>:
.globl vector110
vector110:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $110
80106577:	6a 6e                	push   $0x6e
  jmp alltraps
80106579:	e9 36 f7 ff ff       	jmp    80105cb4 <alltraps>

8010657e <vector111>:
.globl vector111
vector111:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $111
80106580:	6a 6f                	push   $0x6f
  jmp alltraps
80106582:	e9 2d f7 ff ff       	jmp    80105cb4 <alltraps>

80106587 <vector112>:
.globl vector112
vector112:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $112
80106589:	6a 70                	push   $0x70
  jmp alltraps
8010658b:	e9 24 f7 ff ff       	jmp    80105cb4 <alltraps>

80106590 <vector113>:
.globl vector113
vector113:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $113
80106592:	6a 71                	push   $0x71
  jmp alltraps
80106594:	e9 1b f7 ff ff       	jmp    80105cb4 <alltraps>

80106599 <vector114>:
.globl vector114
vector114:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $114
8010659b:	6a 72                	push   $0x72
  jmp alltraps
8010659d:	e9 12 f7 ff ff       	jmp    80105cb4 <alltraps>

801065a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $115
801065a4:	6a 73                	push   $0x73
  jmp alltraps
801065a6:	e9 09 f7 ff ff       	jmp    80105cb4 <alltraps>

801065ab <vector116>:
.globl vector116
vector116:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $116
801065ad:	6a 74                	push   $0x74
  jmp alltraps
801065af:	e9 00 f7 ff ff       	jmp    80105cb4 <alltraps>

801065b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $117
801065b6:	6a 75                	push   $0x75
  jmp alltraps
801065b8:	e9 f7 f6 ff ff       	jmp    80105cb4 <alltraps>

801065bd <vector118>:
.globl vector118
vector118:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $118
801065bf:	6a 76                	push   $0x76
  jmp alltraps
801065c1:	e9 ee f6 ff ff       	jmp    80105cb4 <alltraps>

801065c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $119
801065c8:	6a 77                	push   $0x77
  jmp alltraps
801065ca:	e9 e5 f6 ff ff       	jmp    80105cb4 <alltraps>

801065cf <vector120>:
.globl vector120
vector120:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $120
801065d1:	6a 78                	push   $0x78
  jmp alltraps
801065d3:	e9 dc f6 ff ff       	jmp    80105cb4 <alltraps>

801065d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $121
801065da:	6a 79                	push   $0x79
  jmp alltraps
801065dc:	e9 d3 f6 ff ff       	jmp    80105cb4 <alltraps>

801065e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $122
801065e3:	6a 7a                	push   $0x7a
  jmp alltraps
801065e5:	e9 ca f6 ff ff       	jmp    80105cb4 <alltraps>

801065ea <vector123>:
.globl vector123
vector123:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $123
801065ec:	6a 7b                	push   $0x7b
  jmp alltraps
801065ee:	e9 c1 f6 ff ff       	jmp    80105cb4 <alltraps>

801065f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $124
801065f5:	6a 7c                	push   $0x7c
  jmp alltraps
801065f7:	e9 b8 f6 ff ff       	jmp    80105cb4 <alltraps>

801065fc <vector125>:
.globl vector125
vector125:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $125
801065fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106600:	e9 af f6 ff ff       	jmp    80105cb4 <alltraps>

80106605 <vector126>:
.globl vector126
vector126:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $126
80106607:	6a 7e                	push   $0x7e
  jmp alltraps
80106609:	e9 a6 f6 ff ff       	jmp    80105cb4 <alltraps>

8010660e <vector127>:
.globl vector127
vector127:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $127
80106610:	6a 7f                	push   $0x7f
  jmp alltraps
80106612:	e9 9d f6 ff ff       	jmp    80105cb4 <alltraps>

80106617 <vector128>:
.globl vector128
vector128:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $128
80106619:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010661e:	e9 91 f6 ff ff       	jmp    80105cb4 <alltraps>

80106623 <vector129>:
.globl vector129
vector129:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $129
80106625:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010662a:	e9 85 f6 ff ff       	jmp    80105cb4 <alltraps>

8010662f <vector130>:
.globl vector130
vector130:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $130
80106631:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106636:	e9 79 f6 ff ff       	jmp    80105cb4 <alltraps>

8010663b <vector131>:
.globl vector131
vector131:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $131
8010663d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106642:	e9 6d f6 ff ff       	jmp    80105cb4 <alltraps>

80106647 <vector132>:
.globl vector132
vector132:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $132
80106649:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010664e:	e9 61 f6 ff ff       	jmp    80105cb4 <alltraps>

80106653 <vector133>:
.globl vector133
vector133:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $133
80106655:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010665a:	e9 55 f6 ff ff       	jmp    80105cb4 <alltraps>

8010665f <vector134>:
.globl vector134
vector134:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $134
80106661:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106666:	e9 49 f6 ff ff       	jmp    80105cb4 <alltraps>

8010666b <vector135>:
.globl vector135
vector135:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $135
8010666d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106672:	e9 3d f6 ff ff       	jmp    80105cb4 <alltraps>

80106677 <vector136>:
.globl vector136
vector136:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $136
80106679:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010667e:	e9 31 f6 ff ff       	jmp    80105cb4 <alltraps>

80106683 <vector137>:
.globl vector137
vector137:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $137
80106685:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010668a:	e9 25 f6 ff ff       	jmp    80105cb4 <alltraps>

8010668f <vector138>:
.globl vector138
vector138:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $138
80106691:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106696:	e9 19 f6 ff ff       	jmp    80105cb4 <alltraps>

8010669b <vector139>:
.globl vector139
vector139:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $139
8010669d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066a2:	e9 0d f6 ff ff       	jmp    80105cb4 <alltraps>

801066a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $140
801066a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066ae:	e9 01 f6 ff ff       	jmp    80105cb4 <alltraps>

801066b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $141
801066b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066ba:	e9 f5 f5 ff ff       	jmp    80105cb4 <alltraps>

801066bf <vector142>:
.globl vector142
vector142:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $142
801066c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066c6:	e9 e9 f5 ff ff       	jmp    80105cb4 <alltraps>

801066cb <vector143>:
.globl vector143
vector143:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $143
801066cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066d2:	e9 dd f5 ff ff       	jmp    80105cb4 <alltraps>

801066d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $144
801066d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066de:	e9 d1 f5 ff ff       	jmp    80105cb4 <alltraps>

801066e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $145
801066e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ea:	e9 c5 f5 ff ff       	jmp    80105cb4 <alltraps>

801066ef <vector146>:
.globl vector146
vector146:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $146
801066f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066f6:	e9 b9 f5 ff ff       	jmp    80105cb4 <alltraps>

801066fb <vector147>:
.globl vector147
vector147:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $147
801066fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106702:	e9 ad f5 ff ff       	jmp    80105cb4 <alltraps>

80106707 <vector148>:
.globl vector148
vector148:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $148
80106709:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010670e:	e9 a1 f5 ff ff       	jmp    80105cb4 <alltraps>

80106713 <vector149>:
.globl vector149
vector149:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $149
80106715:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010671a:	e9 95 f5 ff ff       	jmp    80105cb4 <alltraps>

8010671f <vector150>:
.globl vector150
vector150:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $150
80106721:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106726:	e9 89 f5 ff ff       	jmp    80105cb4 <alltraps>

8010672b <vector151>:
.globl vector151
vector151:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $151
8010672d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106732:	e9 7d f5 ff ff       	jmp    80105cb4 <alltraps>

80106737 <vector152>:
.globl vector152
vector152:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $152
80106739:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010673e:	e9 71 f5 ff ff       	jmp    80105cb4 <alltraps>

80106743 <vector153>:
.globl vector153
vector153:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $153
80106745:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010674a:	e9 65 f5 ff ff       	jmp    80105cb4 <alltraps>

8010674f <vector154>:
.globl vector154
vector154:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $154
80106751:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106756:	e9 59 f5 ff ff       	jmp    80105cb4 <alltraps>

8010675b <vector155>:
.globl vector155
vector155:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $155
8010675d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106762:	e9 4d f5 ff ff       	jmp    80105cb4 <alltraps>

80106767 <vector156>:
.globl vector156
vector156:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $156
80106769:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010676e:	e9 41 f5 ff ff       	jmp    80105cb4 <alltraps>

80106773 <vector157>:
.globl vector157
vector157:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $157
80106775:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010677a:	e9 35 f5 ff ff       	jmp    80105cb4 <alltraps>

8010677f <vector158>:
.globl vector158
vector158:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $158
80106781:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106786:	e9 29 f5 ff ff       	jmp    80105cb4 <alltraps>

8010678b <vector159>:
.globl vector159
vector159:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $159
8010678d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106792:	e9 1d f5 ff ff       	jmp    80105cb4 <alltraps>

80106797 <vector160>:
.globl vector160
vector160:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $160
80106799:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010679e:	e9 11 f5 ff ff       	jmp    80105cb4 <alltraps>

801067a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $161
801067a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067aa:	e9 05 f5 ff ff       	jmp    80105cb4 <alltraps>

801067af <vector162>:
.globl vector162
vector162:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $162
801067b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067b6:	e9 f9 f4 ff ff       	jmp    80105cb4 <alltraps>

801067bb <vector163>:
.globl vector163
vector163:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $163
801067bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067c2:	e9 ed f4 ff ff       	jmp    80105cb4 <alltraps>

801067c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $164
801067c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067ce:	e9 e1 f4 ff ff       	jmp    80105cb4 <alltraps>

801067d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $165
801067d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067da:	e9 d5 f4 ff ff       	jmp    80105cb4 <alltraps>

801067df <vector166>:
.globl vector166
vector166:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $166
801067e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067e6:	e9 c9 f4 ff ff       	jmp    80105cb4 <alltraps>

801067eb <vector167>:
.globl vector167
vector167:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $167
801067ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067f2:	e9 bd f4 ff ff       	jmp    80105cb4 <alltraps>

801067f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $168
801067f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067fe:	e9 b1 f4 ff ff       	jmp    80105cb4 <alltraps>

80106803 <vector169>:
.globl vector169
vector169:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $169
80106805:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010680a:	e9 a5 f4 ff ff       	jmp    80105cb4 <alltraps>

8010680f <vector170>:
.globl vector170
vector170:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $170
80106811:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106816:	e9 99 f4 ff ff       	jmp    80105cb4 <alltraps>

8010681b <vector171>:
.globl vector171
vector171:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $171
8010681d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106822:	e9 8d f4 ff ff       	jmp    80105cb4 <alltraps>

80106827 <vector172>:
.globl vector172
vector172:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $172
80106829:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010682e:	e9 81 f4 ff ff       	jmp    80105cb4 <alltraps>

80106833 <vector173>:
.globl vector173
vector173:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $173
80106835:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010683a:	e9 75 f4 ff ff       	jmp    80105cb4 <alltraps>

8010683f <vector174>:
.globl vector174
vector174:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $174
80106841:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106846:	e9 69 f4 ff ff       	jmp    80105cb4 <alltraps>

8010684b <vector175>:
.globl vector175
vector175:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $175
8010684d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106852:	e9 5d f4 ff ff       	jmp    80105cb4 <alltraps>

80106857 <vector176>:
.globl vector176
vector176:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $176
80106859:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010685e:	e9 51 f4 ff ff       	jmp    80105cb4 <alltraps>

80106863 <vector177>:
.globl vector177
vector177:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $177
80106865:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010686a:	e9 45 f4 ff ff       	jmp    80105cb4 <alltraps>

8010686f <vector178>:
.globl vector178
vector178:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $178
80106871:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106876:	e9 39 f4 ff ff       	jmp    80105cb4 <alltraps>

8010687b <vector179>:
.globl vector179
vector179:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $179
8010687d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106882:	e9 2d f4 ff ff       	jmp    80105cb4 <alltraps>

80106887 <vector180>:
.globl vector180
vector180:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $180
80106889:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010688e:	e9 21 f4 ff ff       	jmp    80105cb4 <alltraps>

80106893 <vector181>:
.globl vector181
vector181:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $181
80106895:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010689a:	e9 15 f4 ff ff       	jmp    80105cb4 <alltraps>

8010689f <vector182>:
.globl vector182
vector182:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $182
801068a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068a6:	e9 09 f4 ff ff       	jmp    80105cb4 <alltraps>

801068ab <vector183>:
.globl vector183
vector183:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $183
801068ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068b2:	e9 fd f3 ff ff       	jmp    80105cb4 <alltraps>

801068b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $184
801068b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068be:	e9 f1 f3 ff ff       	jmp    80105cb4 <alltraps>

801068c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $185
801068c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068ca:	e9 e5 f3 ff ff       	jmp    80105cb4 <alltraps>

801068cf <vector186>:
.globl vector186
vector186:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $186
801068d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068d6:	e9 d9 f3 ff ff       	jmp    80105cb4 <alltraps>

801068db <vector187>:
.globl vector187
vector187:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $187
801068dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068e2:	e9 cd f3 ff ff       	jmp    80105cb4 <alltraps>

801068e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $188
801068e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068ee:	e9 c1 f3 ff ff       	jmp    80105cb4 <alltraps>

801068f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $189
801068f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068fa:	e9 b5 f3 ff ff       	jmp    80105cb4 <alltraps>

801068ff <vector190>:
.globl vector190
vector190:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $190
80106901:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106906:	e9 a9 f3 ff ff       	jmp    80105cb4 <alltraps>

8010690b <vector191>:
.globl vector191
vector191:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $191
8010690d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106912:	e9 9d f3 ff ff       	jmp    80105cb4 <alltraps>

80106917 <vector192>:
.globl vector192
vector192:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $192
80106919:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010691e:	e9 91 f3 ff ff       	jmp    80105cb4 <alltraps>

80106923 <vector193>:
.globl vector193
vector193:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $193
80106925:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010692a:	e9 85 f3 ff ff       	jmp    80105cb4 <alltraps>

8010692f <vector194>:
.globl vector194
vector194:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $194
80106931:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106936:	e9 79 f3 ff ff       	jmp    80105cb4 <alltraps>

8010693b <vector195>:
.globl vector195
vector195:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $195
8010693d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106942:	e9 6d f3 ff ff       	jmp    80105cb4 <alltraps>

80106947 <vector196>:
.globl vector196
vector196:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $196
80106949:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010694e:	e9 61 f3 ff ff       	jmp    80105cb4 <alltraps>

80106953 <vector197>:
.globl vector197
vector197:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $197
80106955:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010695a:	e9 55 f3 ff ff       	jmp    80105cb4 <alltraps>

8010695f <vector198>:
.globl vector198
vector198:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $198
80106961:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106966:	e9 49 f3 ff ff       	jmp    80105cb4 <alltraps>

8010696b <vector199>:
.globl vector199
vector199:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $199
8010696d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106972:	e9 3d f3 ff ff       	jmp    80105cb4 <alltraps>

80106977 <vector200>:
.globl vector200
vector200:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $200
80106979:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010697e:	e9 31 f3 ff ff       	jmp    80105cb4 <alltraps>

80106983 <vector201>:
.globl vector201
vector201:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $201
80106985:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010698a:	e9 25 f3 ff ff       	jmp    80105cb4 <alltraps>

8010698f <vector202>:
.globl vector202
vector202:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $202
80106991:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106996:	e9 19 f3 ff ff       	jmp    80105cb4 <alltraps>

8010699b <vector203>:
.globl vector203
vector203:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $203
8010699d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069a2:	e9 0d f3 ff ff       	jmp    80105cb4 <alltraps>

801069a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $204
801069a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069ae:	e9 01 f3 ff ff       	jmp    80105cb4 <alltraps>

801069b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $205
801069b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069ba:	e9 f5 f2 ff ff       	jmp    80105cb4 <alltraps>

801069bf <vector206>:
.globl vector206
vector206:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $206
801069c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069c6:	e9 e9 f2 ff ff       	jmp    80105cb4 <alltraps>

801069cb <vector207>:
.globl vector207
vector207:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $207
801069cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069d2:	e9 dd f2 ff ff       	jmp    80105cb4 <alltraps>

801069d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $208
801069d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069de:	e9 d1 f2 ff ff       	jmp    80105cb4 <alltraps>

801069e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $209
801069e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ea:	e9 c5 f2 ff ff       	jmp    80105cb4 <alltraps>

801069ef <vector210>:
.globl vector210
vector210:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $210
801069f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069f6:	e9 b9 f2 ff ff       	jmp    80105cb4 <alltraps>

801069fb <vector211>:
.globl vector211
vector211:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $211
801069fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a02:	e9 ad f2 ff ff       	jmp    80105cb4 <alltraps>

80106a07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $212
80106a09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a0e:	e9 a1 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $213
80106a15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a1a:	e9 95 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $214
80106a21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a26:	e9 89 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $215
80106a2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a32:	e9 7d f2 ff ff       	jmp    80105cb4 <alltraps>

80106a37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $216
80106a39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a3e:	e9 71 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $217
80106a45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a4a:	e9 65 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $218
80106a51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a56:	e9 59 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $219
80106a5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a62:	e9 4d f2 ff ff       	jmp    80105cb4 <alltraps>

80106a67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $220
80106a69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a6e:	e9 41 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $221
80106a75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a7a:	e9 35 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $222
80106a81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a86:	e9 29 f2 ff ff       	jmp    80105cb4 <alltraps>

80106a8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $223
80106a8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a92:	e9 1d f2 ff ff       	jmp    80105cb4 <alltraps>

80106a97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $224
80106a99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a9e:	e9 11 f2 ff ff       	jmp    80105cb4 <alltraps>

80106aa3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $225
80106aa5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aaa:	e9 05 f2 ff ff       	jmp    80105cb4 <alltraps>

80106aaf <vector226>:
.globl vector226
vector226:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $226
80106ab1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ab6:	e9 f9 f1 ff ff       	jmp    80105cb4 <alltraps>

80106abb <vector227>:
.globl vector227
vector227:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $227
80106abd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ac2:	e9 ed f1 ff ff       	jmp    80105cb4 <alltraps>

80106ac7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $228
80106ac9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ace:	e9 e1 f1 ff ff       	jmp    80105cb4 <alltraps>

80106ad3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $229
80106ad5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106ada:	e9 d5 f1 ff ff       	jmp    80105cb4 <alltraps>

80106adf <vector230>:
.globl vector230
vector230:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $230
80106ae1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ae6:	e9 c9 f1 ff ff       	jmp    80105cb4 <alltraps>

80106aeb <vector231>:
.globl vector231
vector231:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $231
80106aed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106af2:	e9 bd f1 ff ff       	jmp    80105cb4 <alltraps>

80106af7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $232
80106af9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106afe:	e9 b1 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $233
80106b05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b0a:	e9 a5 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $234
80106b11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b16:	e9 99 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $235
80106b1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b22:	e9 8d f1 ff ff       	jmp    80105cb4 <alltraps>

80106b27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $236
80106b29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b2e:	e9 81 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $237
80106b35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b3a:	e9 75 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $238
80106b41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b46:	e9 69 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $239
80106b4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b52:	e9 5d f1 ff ff       	jmp    80105cb4 <alltraps>

80106b57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $240
80106b59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b5e:	e9 51 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $241
80106b65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b6a:	e9 45 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $242
80106b71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b76:	e9 39 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $243
80106b7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b82:	e9 2d f1 ff ff       	jmp    80105cb4 <alltraps>

80106b87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $244
80106b89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b8e:	e9 21 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $245
80106b95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b9a:	e9 15 f1 ff ff       	jmp    80105cb4 <alltraps>

80106b9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $246
80106ba1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ba6:	e9 09 f1 ff ff       	jmp    80105cb4 <alltraps>

80106bab <vector247>:
.globl vector247
vector247:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $247
80106bad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bb2:	e9 fd f0 ff ff       	jmp    80105cb4 <alltraps>

80106bb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $248
80106bb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bbe:	e9 f1 f0 ff ff       	jmp    80105cb4 <alltraps>

80106bc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $249
80106bc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bca:	e9 e5 f0 ff ff       	jmp    80105cb4 <alltraps>

80106bcf <vector250>:
.globl vector250
vector250:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $250
80106bd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bd6:	e9 d9 f0 ff ff       	jmp    80105cb4 <alltraps>

80106bdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $251
80106bdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106be2:	e9 cd f0 ff ff       	jmp    80105cb4 <alltraps>

80106be7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $252
80106be9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bee:	e9 c1 f0 ff ff       	jmp    80105cb4 <alltraps>

80106bf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $253
80106bf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bfa:	e9 b5 f0 ff ff       	jmp    80105cb4 <alltraps>

80106bff <vector254>:
.globl vector254
vector254:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $254
80106c01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c06:	e9 a9 f0 ff ff       	jmp    80105cb4 <alltraps>

80106c0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $255
80106c0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c12:	e9 9d f0 ff ff       	jmp    80105cb4 <alltraps>
80106c17:	66 90                	xchg   %ax,%ax
80106c19:	66 90                	xchg   %ax,%ax
80106c1b:	66 90                	xchg   %ax,%ax
80106c1d:	66 90                	xchg   %ax,%ax
80106c1f:	90                   	nop

80106c20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c32:	83 ec 1c             	sub    $0x1c,%esp
80106c35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c38:	39 d3                	cmp    %edx,%ebx
80106c3a:	73 49                	jae    80106c85 <deallocuvm.part.0+0x65>
80106c3c:	89 c7                	mov    %eax,%edi
80106c3e:	eb 0c                	jmp    80106c4c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c40:	83 c0 01             	add    $0x1,%eax
80106c43:	c1 e0 16             	shl    $0x16,%eax
80106c46:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c48:	39 da                	cmp    %ebx,%edx
80106c4a:	76 39                	jbe    80106c85 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106c4c:	89 d8                	mov    %ebx,%eax
80106c4e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106c51:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106c54:	f6 c1 01             	test   $0x1,%cl
80106c57:	74 e7                	je     80106c40 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106c59:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c61:	c1 ee 0a             	shr    $0xa,%esi
80106c64:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106c6a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106c71:	85 f6                	test   %esi,%esi
80106c73:	74 cb                	je     80106c40 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106c75:	8b 06                	mov    (%esi),%eax
80106c77:	a8 01                	test   $0x1,%al
80106c79:	75 15                	jne    80106c90 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106c7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c81:	39 da                	cmp    %ebx,%edx
80106c83:	77 c7                	ja     80106c4c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c8b:	5b                   	pop    %ebx
80106c8c:	5e                   	pop    %esi
80106c8d:	5f                   	pop    %edi
80106c8e:	5d                   	pop    %ebp
80106c8f:	c3                   	ret    
      if(pa == 0)
80106c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c95:	74 25                	je     80106cbc <deallocuvm.part.0+0x9c>
      kfree(v);
80106c97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c9a:	05 00 00 00 80       	add    $0x80000000,%eax
80106c9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ca2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ca8:	50                   	push   %eax
80106ca9:	e8 22 b8 ff ff       	call   801024d0 <kfree>
      *pte = 0;
80106cae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106cb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106cb7:	83 c4 10             	add    $0x10,%esp
80106cba:	eb 8c                	jmp    80106c48 <deallocuvm.part.0+0x28>
        panic("kfree");
80106cbc:	83 ec 0c             	sub    $0xc,%esp
80106cbf:	68 86 78 10 80       	push   $0x80107886
80106cc4:	e8 b7 96 ff ff       	call   80100380 <panic>
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cd0 <mappages>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106cd6:	89 d3                	mov    %edx,%ebx
80106cd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cde:	83 ec 1c             	sub    $0x1c,%esp
80106ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ce4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ced:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf3:	29 d8                	sub    %ebx,%eax
80106cf5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cf8:	eb 3d                	jmp    80106d37 <mappages+0x67>
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d00:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d07:	c1 ea 0a             	shr    $0xa,%edx
80106d0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d17:	85 c0                	test   %eax,%eax
80106d19:	74 75                	je     80106d90 <mappages+0xc0>
    if(*pte & PTE_P)
80106d1b:	f6 00 01             	testb  $0x1,(%eax)
80106d1e:	0f 85 86 00 00 00    	jne    80106daa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d24:	0b 75 0c             	or     0xc(%ebp),%esi
80106d27:	83 ce 01             	or     $0x1,%esi
80106d2a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d2c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106d2f:	74 6f                	je     80106da0 <mappages+0xd0>
    a += PGSIZE;
80106d31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106d37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106d3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d3d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106d40:	89 d8                	mov    %ebx,%eax
80106d42:	c1 e8 16             	shr    $0x16,%eax
80106d45:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106d48:	8b 07                	mov    (%edi),%eax
80106d4a:	a8 01                	test   $0x1,%al
80106d4c:	75 b2                	jne    80106d00 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d4e:	e8 3d b9 ff ff       	call   80102690 <kalloc>
80106d53:	85 c0                	test   %eax,%eax
80106d55:	74 39                	je     80106d90 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106d57:	83 ec 04             	sub    $0x4,%esp
80106d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106d5d:	68 00 10 00 00       	push   $0x1000
80106d62:	6a 00                	push   $0x0
80106d64:	50                   	push   %eax
80106d65:	e8 c6 d9 ff ff       	call   80104730 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106d6d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d70:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106d76:	83 c8 07             	or     $0x7,%eax
80106d79:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106d7b:	89 d8                	mov    %ebx,%eax
80106d7d:	c1 e8 0a             	shr    $0xa,%eax
80106d80:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d85:	01 d0                	add    %edx,%eax
80106d87:	eb 92                	jmp    80106d1b <mappages+0x4b>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d98:	5b                   	pop    %ebx
80106d99:	5e                   	pop    %esi
80106d9a:	5f                   	pop    %edi
80106d9b:	5d                   	pop    %ebp
80106d9c:	c3                   	ret    
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
80106da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106da3:	31 c0                	xor    %eax,%eax
}
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
      panic("remap");
80106daa:	83 ec 0c             	sub    $0xc,%esp
80106dad:	68 48 8b 10 80       	push   $0x80108b48
80106db2:	e8 c9 95 ff ff       	call   80100380 <panic>
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <seginit>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106dc6:	e8 95 cb ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106dcb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106dd0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106dd6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dda:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106de1:	ff 00 00 
80106de4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106deb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dee:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106df5:	ff 00 00 
80106df8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106dff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e02:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e09:	ff 00 00 
80106e0c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e16:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e1d:	ff 00 00 
80106e20:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e2a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e33:	c1 e8 10             	shr    $0x10,%eax
80106e36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e3d:	0f 01 10             	lgdtl  (%eax)
}
80106e40:	c9                   	leave  
80106e41:	c3                   	ret    
80106e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	a1 c4 54 11 80       	mov    0x801154c4,%eax
80106e55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e5a:	0f 22 d8             	mov    %eax,%cr3
}
80106e5d:	c3                   	ret    
80106e5e:	66 90                	xchg   %ax,%ax

80106e60 <switchuvm>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
80106e66:	83 ec 1c             	sub    $0x1c,%esp
80106e69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e6c:	85 f6                	test   %esi,%esi
80106e6e:	0f 84 cb 00 00 00    	je     80106f3f <switchuvm+0xdf>
  if(p->kstack == 0)
80106e74:	8b 46 08             	mov    0x8(%esi),%eax
80106e77:	85 c0                	test   %eax,%eax
80106e79:	0f 84 da 00 00 00    	je     80106f59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e7f:	8b 46 04             	mov    0x4(%esi),%eax
80106e82:	85 c0                	test   %eax,%eax
80106e84:	0f 84 c2 00 00 00    	je     80106f4c <switchuvm+0xec>
  pushcli();
80106e8a:	e8 91 d6 ff ff       	call   80104520 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e8f:	e8 6c ca ff ff       	call   80103900 <mycpu>
80106e94:	89 c3                	mov    %eax,%ebx
80106e96:	e8 65 ca ff ff       	call   80103900 <mycpu>
80106e9b:	89 c7                	mov    %eax,%edi
80106e9d:	e8 5e ca ff ff       	call   80103900 <mycpu>
80106ea2:	83 c7 08             	add    $0x8,%edi
80106ea5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ea8:	e8 53 ca ff ff       	call   80103900 <mycpu>
80106ead:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106eb0:	ba 67 00 00 00       	mov    $0x67,%edx
80106eb5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ebc:	83 c0 08             	add    $0x8,%eax
80106ebf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ec6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ecb:	83 c1 08             	add    $0x8,%ecx
80106ece:	c1 e8 18             	shr    $0x18,%eax
80106ed1:	c1 e9 10             	shr    $0x10,%ecx
80106ed4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106eda:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ee0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ee5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ef1:	e8 0a ca ff ff       	call   80103900 <mycpu>
80106ef6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106efd:	e8 fe c9 ff ff       	call   80103900 <mycpu>
80106f02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f06:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f0f:	e8 ec c9 ff ff       	call   80103900 <mycpu>
80106f14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f17:	e8 e4 c9 ff ff       	call   80103900 <mycpu>
80106f1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f20:	b8 28 00 00 00       	mov    $0x28,%eax
80106f25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f28:	8b 46 04             	mov    0x4(%esi),%eax
80106f2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f30:	0f 22 d8             	mov    %eax,%cr3
}
80106f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f36:	5b                   	pop    %ebx
80106f37:	5e                   	pop    %esi
80106f38:	5f                   	pop    %edi
80106f39:	5d                   	pop    %ebp
  popcli();
80106f3a:	e9 31 d6 ff ff       	jmp    80104570 <popcli>
    panic("switchuvm: no process");
80106f3f:	83 ec 0c             	sub    $0xc,%esp
80106f42:	68 4e 8b 10 80       	push   $0x80108b4e
80106f47:	e8 34 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106f4c:	83 ec 0c             	sub    $0xc,%esp
80106f4f:	68 79 8b 10 80       	push   $0x80108b79
80106f54:	e8 27 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106f59:	83 ec 0c             	sub    $0xc,%esp
80106f5c:	68 64 8b 10 80       	push   $0x80108b64
80106f61:	e8 1a 94 ff ff       	call   80100380 <panic>
80106f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi

80106f70 <inituvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 1c             	sub    $0x1c,%esp
80106f79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f7c:	8b 75 10             	mov    0x10(%ebp),%esi
80106f7f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f8b:	77 4b                	ja     80106fd8 <inituvm+0x68>
  mem = kalloc();
80106f8d:	e8 fe b6 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80106f92:	83 ec 04             	sub    $0x4,%esp
80106f95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f9c:	6a 00                	push   $0x0
80106f9e:	50                   	push   %eax
80106f9f:	e8 8c d7 ff ff       	call   80104730 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106fa4:	58                   	pop    %eax
80106fa5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fab:	5a                   	pop    %edx
80106fac:	6a 06                	push   $0x6
80106fae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fb3:	31 d2                	xor    %edx,%edx
80106fb5:	50                   	push   %eax
80106fb6:	89 f8                	mov    %edi,%eax
80106fb8:	e8 13 fd ff ff       	call   80106cd0 <mappages>
  memmove(mem, init, sz);
80106fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fc0:	89 75 10             	mov    %esi,0x10(%ebp)
80106fc3:	83 c4 10             	add    $0x10,%esp
80106fc6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106fc9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fcf:	5b                   	pop    %ebx
80106fd0:	5e                   	pop    %esi
80106fd1:	5f                   	pop    %edi
80106fd2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106fd3:	e9 f8 d7 ff ff       	jmp    801047d0 <memmove>
    panic("inituvm: more than a page");
80106fd8:	83 ec 0c             	sub    $0xc,%esp
80106fdb:	68 8d 8b 10 80       	push   $0x80108b8d
80106fe0:	e8 9b 93 ff ff       	call   80100380 <panic>
80106fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <loaduvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ffc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106fff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107004:	0f 85 bb 00 00 00    	jne    801070c5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010700a:	01 f0                	add    %esi,%eax
8010700c:	89 f3                	mov    %esi,%ebx
8010700e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107011:	8b 45 14             	mov    0x14(%ebp),%eax
80107014:	01 f0                	add    %esi,%eax
80107016:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107019:	85 f6                	test   %esi,%esi
8010701b:	0f 84 87 00 00 00    	je     801070a8 <loaduvm+0xb8>
80107021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010702b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010702e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107030:	89 c2                	mov    %eax,%edx
80107032:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107035:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107038:	f6 c2 01             	test   $0x1,%dl
8010703b:	75 13                	jne    80107050 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010703d:	83 ec 0c             	sub    $0xc,%esp
80107040:	68 a7 8b 10 80       	push   $0x80108ba7
80107045:	e8 36 93 ff ff       	call   80100380 <panic>
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107050:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107053:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107059:	25 fc 0f 00 00       	and    $0xffc,%eax
8010705e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107065:	85 c0                	test   %eax,%eax
80107067:	74 d4                	je     8010703d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107069:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010706b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010706e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107073:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107078:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010707e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107081:	29 d9                	sub    %ebx,%ecx
80107083:	05 00 00 00 80       	add    $0x80000000,%eax
80107088:	57                   	push   %edi
80107089:	51                   	push   %ecx
8010708a:	50                   	push   %eax
8010708b:	ff 75 10             	push   0x10(%ebp)
8010708e:	e8 fd a9 ff ff       	call   80101a90 <readi>
80107093:	83 c4 10             	add    $0x10,%esp
80107096:	39 f8                	cmp    %edi,%eax
80107098:	75 1e                	jne    801070b8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010709a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801070a0:	89 f0                	mov    %esi,%eax
801070a2:	29 d8                	sub    %ebx,%eax
801070a4:	39 c6                	cmp    %eax,%esi
801070a6:	77 80                	ja     80107028 <loaduvm+0x38>
}
801070a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070ab:	31 c0                	xor    %eax,%eax
}
801070ad:	5b                   	pop    %ebx
801070ae:	5e                   	pop    %esi
801070af:	5f                   	pop    %edi
801070b0:	5d                   	pop    %ebp
801070b1:	c3                   	ret    
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c0:	5b                   	pop    %ebx
801070c1:	5e                   	pop    %esi
801070c2:	5f                   	pop    %edi
801070c3:	5d                   	pop    %ebp
801070c4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801070c5:	83 ec 0c             	sub    $0xc,%esp
801070c8:	68 48 8c 10 80       	push   $0x80108c48
801070cd:	e8 ae 92 ff ff       	call   80100380 <panic>
801070d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070e0 <allocuvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070e9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801070ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801070ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070f2:	85 c0                	test   %eax,%eax
801070f4:	0f 88 b6 00 00 00    	js     801071b0 <allocuvm+0xd0>
  if(newsz < oldsz)
801070fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801070fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107100:	0f 82 9a 00 00 00    	jb     801071a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107106:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010710c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107112:	39 75 10             	cmp    %esi,0x10(%ebp)
80107115:	77 44                	ja     8010715b <allocuvm+0x7b>
80107117:	e9 87 00 00 00       	jmp    801071a3 <allocuvm+0xc3>
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107120:	83 ec 04             	sub    $0x4,%esp
80107123:	68 00 10 00 00       	push   $0x1000
80107128:	6a 00                	push   $0x0
8010712a:	50                   	push   %eax
8010712b:	e8 00 d6 ff ff       	call   80104730 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107130:	58                   	pop    %eax
80107131:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107137:	5a                   	pop    %edx
80107138:	6a 06                	push   $0x6
8010713a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010713f:	89 f2                	mov    %esi,%edx
80107141:	50                   	push   %eax
80107142:	89 f8                	mov    %edi,%eax
80107144:	e8 87 fb ff ff       	call   80106cd0 <mappages>
80107149:	83 c4 10             	add    $0x10,%esp
8010714c:	85 c0                	test   %eax,%eax
8010714e:	78 78                	js     801071c8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107150:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107156:	39 75 10             	cmp    %esi,0x10(%ebp)
80107159:	76 48                	jbe    801071a3 <allocuvm+0xc3>
    mem = kalloc();
8010715b:	e8 30 b5 ff ff       	call   80102690 <kalloc>
80107160:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107162:	85 c0                	test   %eax,%eax
80107164:	75 ba                	jne    80107120 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	68 c5 8b 10 80       	push   $0x80108bc5
8010716e:	e8 2d 95 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107173:	8b 45 0c             	mov    0xc(%ebp),%eax
80107176:	83 c4 10             	add    $0x10,%esp
80107179:	39 45 10             	cmp    %eax,0x10(%ebp)
8010717c:	74 32                	je     801071b0 <allocuvm+0xd0>
8010717e:	8b 55 10             	mov    0x10(%ebp),%edx
80107181:	89 c1                	mov    %eax,%ecx
80107183:	89 f8                	mov    %edi,%eax
80107185:	e8 96 fa ff ff       	call   80106c20 <deallocuvm.part.0>
      return 0;
8010718a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107197:	5b                   	pop    %ebx
80107198:	5e                   	pop    %esi
80107199:	5f                   	pop    %edi
8010719a:	5d                   	pop    %ebp
8010719b:	c3                   	ret    
8010719c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801071a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801071a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a9:	5b                   	pop    %ebx
801071aa:	5e                   	pop    %esi
801071ab:	5f                   	pop    %edi
801071ac:	5d                   	pop    %ebp
801071ad:	c3                   	ret    
801071ae:	66 90                	xchg   %ax,%ax
    return 0;
801071b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801071b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071bd:	5b                   	pop    %ebx
801071be:	5e                   	pop    %esi
801071bf:	5f                   	pop    %edi
801071c0:	5d                   	pop    %ebp
801071c1:	c3                   	ret    
801071c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071c8:	83 ec 0c             	sub    $0xc,%esp
801071cb:	68 dd 8b 10 80       	push   $0x80108bdd
801071d0:	e8 cb 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801071d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801071d8:	83 c4 10             	add    $0x10,%esp
801071db:	39 45 10             	cmp    %eax,0x10(%ebp)
801071de:	74 0c                	je     801071ec <allocuvm+0x10c>
801071e0:	8b 55 10             	mov    0x10(%ebp),%edx
801071e3:	89 c1                	mov    %eax,%ecx
801071e5:	89 f8                	mov    %edi,%eax
801071e7:	e8 34 fa ff ff       	call   80106c20 <deallocuvm.part.0>
      kfree(mem);
801071ec:	83 ec 0c             	sub    $0xc,%esp
801071ef:	53                   	push   %ebx
801071f0:	e8 db b2 ff ff       	call   801024d0 <kfree>
      return 0;
801071f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801071fc:	83 c4 10             	add    $0x10,%esp
}
801071ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107210 <deallocuvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	8b 55 0c             	mov    0xc(%ebp),%edx
80107216:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010721c:	39 d1                	cmp    %edx,%ecx
8010721e:	73 10                	jae    80107230 <deallocuvm+0x20>
}
80107220:	5d                   	pop    %ebp
80107221:	e9 fa f9 ff ff       	jmp    80106c20 <deallocuvm.part.0>
80107226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
80107230:	89 d0                	mov    %edx,%eax
80107232:	5d                   	pop    %ebp
80107233:	c3                   	ret    
80107234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop

80107240 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010724c:	85 f6                	test   %esi,%esi
8010724e:	74 59                	je     801072a9 <freevm+0x69>
  if(newsz >= oldsz)
80107250:	31 c9                	xor    %ecx,%ecx
80107252:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107257:	89 f0                	mov    %esi,%eax
80107259:	89 f3                	mov    %esi,%ebx
8010725b:	e8 c0 f9 ff ff       	call   80106c20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107260:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107266:	eb 0f                	jmp    80107277 <freevm+0x37>
80107268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726f:	90                   	nop
80107270:	83 c3 04             	add    $0x4,%ebx
80107273:	39 df                	cmp    %ebx,%edi
80107275:	74 23                	je     8010729a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107277:	8b 03                	mov    (%ebx),%eax
80107279:	a8 01                	test   $0x1,%al
8010727b:	74 f3                	je     80107270 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010727d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107282:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107285:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107288:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010728d:	50                   	push   %eax
8010728e:	e8 3d b2 ff ff       	call   801024d0 <kfree>
80107293:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107296:	39 df                	cmp    %ebx,%edi
80107298:	75 dd                	jne    80107277 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010729a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010729d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a0:	5b                   	pop    %ebx
801072a1:	5e                   	pop    %esi
801072a2:	5f                   	pop    %edi
801072a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072a4:	e9 27 b2 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
801072a9:	83 ec 0c             	sub    $0xc,%esp
801072ac:	68 f9 8b 10 80       	push   $0x80108bf9
801072b1:	e8 ca 90 ff ff       	call   80100380 <panic>
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi

801072c0 <setupkvm>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	56                   	push   %esi
801072c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072c5:	e8 c6 b3 ff ff       	call   80102690 <kalloc>
801072ca:	89 c6                	mov    %eax,%esi
801072cc:	85 c0                	test   %eax,%eax
801072ce:	74 42                	je     80107312 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801072d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801072d8:	68 00 10 00 00       	push   $0x1000
801072dd:	6a 00                	push   $0x0
801072df:	50                   	push   %eax
801072e0:	e8 4b d4 ff ff       	call   80104730 <memset>
801072e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072eb:	83 ec 08             	sub    $0x8,%esp
801072ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072f1:	ff 73 0c             	push   0xc(%ebx)
801072f4:	8b 13                	mov    (%ebx),%edx
801072f6:	50                   	push   %eax
801072f7:	29 c1                	sub    %eax,%ecx
801072f9:	89 f0                	mov    %esi,%eax
801072fb:	e8 d0 f9 ff ff       	call   80106cd0 <mappages>
80107300:	83 c4 10             	add    $0x10,%esp
80107303:	85 c0                	test   %eax,%eax
80107305:	78 19                	js     80107320 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107307:	83 c3 10             	add    $0x10,%ebx
8010730a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107310:	75 d6                	jne    801072e8 <setupkvm+0x28>
}
80107312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107315:	89 f0                	mov    %esi,%eax
80107317:	5b                   	pop    %ebx
80107318:	5e                   	pop    %esi
80107319:	5d                   	pop    %ebp
8010731a:	c3                   	ret    
8010731b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010731f:	90                   	nop
      freevm(pgdir);
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	56                   	push   %esi
      return 0;
80107324:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107326:	e8 15 ff ff ff       	call   80107240 <freevm>
      return 0;
8010732b:	83 c4 10             	add    $0x10,%esp
}
8010732e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107331:	89 f0                	mov    %esi,%eax
80107333:	5b                   	pop    %ebx
80107334:	5e                   	pop    %esi
80107335:	5d                   	pop    %ebp
80107336:	c3                   	ret    
80107337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733e:	66 90                	xchg   %ax,%ax

80107340 <kvmalloc>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107346:	e8 75 ff ff ff       	call   801072c0 <setupkvm>
8010734b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107350:	05 00 00 00 80       	add    $0x80000000,%eax
80107355:	0f 22 d8             	mov    %eax,%cr3
}
80107358:	c9                   	leave  
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	83 ec 08             	sub    $0x8,%esp
80107366:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107369:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010736c:	89 c1                	mov    %eax,%ecx
8010736e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107371:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107374:	f6 c2 01             	test   $0x1,%dl
80107377:	75 17                	jne    80107390 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107379:	83 ec 0c             	sub    $0xc,%esp
8010737c:	68 0a 8c 10 80       	push   $0x80108c0a
80107381:	e8 fa 8f ff ff       	call   80100380 <panic>
80107386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107390:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107393:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107399:	25 fc 0f 00 00       	and    $0xffc,%eax
8010739e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073a5:	85 c0                	test   %eax,%eax
801073a7:	74 d0                	je     80107379 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073ac:	c9                   	leave  
801073ad:	c3                   	ret    
801073ae:	66 90                	xchg   %ax,%ax

801073b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073b9:	e8 02 ff ff ff       	call   801072c0 <setupkvm>
801073be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073c1:	85 c0                	test   %eax,%eax
801073c3:	0f 84 bd 00 00 00    	je     80107486 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073cc:	85 c9                	test   %ecx,%ecx
801073ce:	0f 84 b2 00 00 00    	je     80107486 <copyuvm+0xd6>
801073d4:	31 f6                	xor    %esi,%esi
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801073e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801073e3:	89 f0                	mov    %esi,%eax
801073e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801073e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801073eb:	a8 01                	test   $0x1,%al
801073ed:	75 11                	jne    80107400 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801073ef:	83 ec 0c             	sub    $0xc,%esp
801073f2:	68 14 8c 10 80       	push   $0x80108c14
801073f7:	e8 84 8f ff ff       	call   80100380 <panic>
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107400:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107407:	c1 ea 0a             	shr    $0xa,%edx
8010740a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107410:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107417:	85 c0                	test   %eax,%eax
80107419:	74 d4                	je     801073ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010741b:	8b 00                	mov    (%eax),%eax
8010741d:	a8 01                	test   $0x1,%al
8010741f:	0f 84 9f 00 00 00    	je     801074c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107425:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107427:	25 ff 0f 00 00       	and    $0xfff,%eax
8010742c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010742f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107435:	e8 56 b2 ff ff       	call   80102690 <kalloc>
8010743a:	89 c3                	mov    %eax,%ebx
8010743c:	85 c0                	test   %eax,%eax
8010743e:	74 64                	je     801074a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107440:	83 ec 04             	sub    $0x4,%esp
80107443:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107449:	68 00 10 00 00       	push   $0x1000
8010744e:	57                   	push   %edi
8010744f:	50                   	push   %eax
80107450:	e8 7b d3 ff ff       	call   801047d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107455:	58                   	pop    %eax
80107456:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010745c:	5a                   	pop    %edx
8010745d:	ff 75 e4             	push   -0x1c(%ebp)
80107460:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107465:	89 f2                	mov    %esi,%edx
80107467:	50                   	push   %eax
80107468:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010746b:	e8 60 f8 ff ff       	call   80106cd0 <mappages>
80107470:	83 c4 10             	add    $0x10,%esp
80107473:	85 c0                	test   %eax,%eax
80107475:	78 21                	js     80107498 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107477:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010747d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107480:	0f 87 5a ff ff ff    	ja     801073e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107486:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748c:	5b                   	pop    %ebx
8010748d:	5e                   	pop    %esi
8010748e:	5f                   	pop    %edi
8010748f:	5d                   	pop    %ebp
80107490:	c3                   	ret    
80107491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	53                   	push   %ebx
8010749c:	e8 2f b0 ff ff       	call   801024d0 <kfree>
      goto bad;
801074a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074a4:	83 ec 0c             	sub    $0xc,%esp
801074a7:	ff 75 e0             	push   -0x20(%ebp)
801074aa:	e8 91 fd ff ff       	call   80107240 <freevm>
  return 0;
801074af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801074b6:	83 c4 10             	add    $0x10,%esp
}
801074b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074bf:	5b                   	pop    %ebx
801074c0:	5e                   	pop    %esi
801074c1:	5f                   	pop    %edi
801074c2:	5d                   	pop    %ebp
801074c3:	c3                   	ret    
      panic("copyuvm: page not present");
801074c4:	83 ec 0c             	sub    $0xc,%esp
801074c7:	68 2e 8c 10 80       	push   $0x80108c2e
801074cc:	e8 af 8e ff ff       	call   80100380 <panic>
801074d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074df:	90                   	nop

801074e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801074e9:	89 c1                	mov    %eax,%ecx
801074eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801074f1:	f6 c2 01             	test   $0x1,%dl
801074f4:	0f 84 00 01 00 00    	je     801075fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801074fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107503:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107504:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107509:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107510:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107512:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107517:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010751a:	05 00 00 00 80       	add    $0x80000000,%eax
8010751f:	83 fa 05             	cmp    $0x5,%edx
80107522:	ba 00 00 00 00       	mov    $0x0,%edx
80107527:	0f 45 c2             	cmovne %edx,%eax
}
8010752a:	c3                   	ret    
8010752b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop

80107530 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	8b 75 14             	mov    0x14(%ebp),%esi
8010753c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010753f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107542:	85 f6                	test   %esi,%esi
80107544:	75 51                	jne    80107597 <copyout+0x67>
80107546:	e9 a5 00 00 00       	jmp    801075f0 <copyout+0xc0>
8010754b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107550:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107556:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010755c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107562:	74 75                	je     801075d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107564:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107566:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107569:	29 c3                	sub    %eax,%ebx
8010756b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107571:	39 f3                	cmp    %esi,%ebx
80107573:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107576:	29 f8                	sub    %edi,%eax
80107578:	83 ec 04             	sub    $0x4,%esp
8010757b:	01 c1                	add    %eax,%ecx
8010757d:	53                   	push   %ebx
8010757e:	52                   	push   %edx
8010757f:	51                   	push   %ecx
80107580:	e8 4b d2 ff ff       	call   801047d0 <memmove>
    len -= n;
    buf += n;
80107585:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107588:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010758e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107591:	01 da                	add    %ebx,%edx
  while(len > 0){
80107593:	29 de                	sub    %ebx,%esi
80107595:	74 59                	je     801075f0 <copyout+0xc0>
  if(*pde & PTE_P){
80107597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010759a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010759c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010759e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801075a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801075aa:	f6 c1 01             	test   $0x1,%cl
801075ad:	0f 84 4e 00 00 00    	je     80107601 <copyout.cold>
  return &pgtab[PTX(va)];
801075b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801075bb:	c1 eb 0c             	shr    $0xc,%ebx
801075be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801075c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801075cb:	89 d9                	mov    %ebx,%ecx
801075cd:	83 e1 05             	and    $0x5,%ecx
801075d0:	83 f9 05             	cmp    $0x5,%ecx
801075d3:	0f 84 77 ff ff ff    	je     80107550 <copyout+0x20>
  }
  return 0;
}
801075d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075e1:	5b                   	pop    %ebx
801075e2:	5e                   	pop    %esi
801075e3:	5f                   	pop    %edi
801075e4:	5d                   	pop    %ebp
801075e5:	c3                   	ret    
801075e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
801075f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075f3:	31 c0                	xor    %eax,%eax
}
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    

801075fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801075fa:	a1 00 00 00 00       	mov    0x0,%eax
801075ff:	0f 0b                	ud2    

80107601 <copyout.cold>:
80107601:	a1 00 00 00 00       	mov    0x0,%eax
80107606:	0f 0b                	ud2    
