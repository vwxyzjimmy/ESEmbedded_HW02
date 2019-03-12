HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------

HW02
===
**1. 實驗題目**
---
1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

**2. 實驗步驟**
---
1. 設計觀察程式如下，將 1、2、3 移置 r1、r2、r3 以利後續觀察，以 r1、r2、r3 push 至 stack 在 pop 至 r4、r5、r6，改變 `push {r1, r2, r3}` 及 `pop {r4, r5, r6}` 順序觀察，共分三組做實驗。
```assembly
.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	nop

	//
	//branch w/o link
	//
	movs	r1, #1
	movs	r2, #2
	movs	r3, #3

	push	{r1, r2, r3}
	pop		{r4, r5, r6}

	movs	r4, #0
	movs	r5, #0
	movs	r6, #0

	push	{r3, r2, r1}
	pop		{r4, r5, r6}

	movs	r4, #0
	movs	r5, #0
	movs	r6, #0

	push	{r1, r2, r3}
	pop		{r6, r5, r4}
	b	label01

label01:
	nop

	//
	//branch w/ link
	//
	bl	sleep

sleep:
	nop
	b	.
```
2. 以 qemu 模擬 gdb 觀察
1.第一組
    ```assembly
    push	{r1, r2, r3}
    pop		{r4, r5, r6}
    ```
    以 gdb 觀察之結果如下
    push 前
![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/1.JPG)
push 後，並觀察 stack 的順序，stack 從頂部 0x20000100 開始往下，可觀察到依序 push 進 r3, r2, r1
![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/2.JPG)
pop 至 r4, r5, r6，可觀察到 stack 從底部 0x200000f4 依序 pop 至 r4, r5, r6。
![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/3.JPG)
    2. 第二組， push 內的順序與第一組相反
    ```assembly
    push	{r3, r2, r1}
	pop		{r4, r5, r6}
    ```
    以 gdb 觀察之結果如下
    push 前，gdb 觀察 push 及 pop 的指令與第一組 gdb 觀察的順序相同，與 main.s 程式的順序不同
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/4.JPG)
    push 後
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/5.JPG)
    pop 後
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/6.JPG)
    與第一組之結果相同，程式內 push 內的順序不影響實際 push 的順序
    3. 第三組， pop 內的順序與第一組相反
    ```assembly
        push	{r1, r2, r3}
        pop		{r6, r5, r4}
    ```
    以 gdb 觀察之結果如下
    push 前，gdb 觀察 push 及 pop 的指令與第一組及第二組 gdb 觀察的順序相同，與 main.s 程式的順序不同
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/7.JPG)
    push 後
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/8.JPG)
    pop 後
    ![](https://github.com/vwxyzjimmy/ESEmbedded_HW02/blob/master/lab2_jpg/9.JPG)
    與第一組及第二組結果相同，程式內 pop 內的順序也不影響實際 pop 的順序。

**3. 結果與討論**
---
push 及 pop 在組合語言內更改的順序都不影響實際程式執行時 push 及 pop 的順序，
[Arm Infomation Center RealView Compilation Tools Assembler Guide 4.2.9. PUSH and POP
](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0204j/Babefbce.html) 說明:
* Registers are stored on the stack in numerical order, with the lowest numbered register at the lowest address.

代表不管是 push 或 pop ，同一指令內 register 數值越小，就從越低之 address 依序存取，好處是存取 stack 時，只需知道上一指令 push 進去的 register ，就能依照 register 大小依序存取 stack ，而不用再去紀錄同一指令內 push 進去之順序，pop 同理只需知道 pop 出之 register ，就能依照 register 編號大小依序獲得 stack 的順序。
