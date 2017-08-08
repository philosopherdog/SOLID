import UIKit

/*:
 ## Agile Design
 
 * With time all complex programs naturally exibits a kind of entropy, which is technically referred to as "rot".
 * Rotting code becomes harder & harder to maintain and add features to.
 * In non-agile shops design begins to degrade as requirements change.
 * Although initally changes to the code may "work", in time violations accumulate and rot sets in.
 
 
 ### The Signs of Software Rot (Design Smells)
 
 * _Rigidity_: hard to change; even simple changes can affect other parts of the program (often unanticipated) and require changes.
 * _Fragility_: changes cause code to break in unrelated parts of the code.
 * _Immobility_: difficult to disentangle code for reuse (lacks modularity).
 * _Viscosity_: changes that preserve the design are harder to make than hacks, which means that the design begins to deteriorate with time.
 * _Needless Complexity_: includes infrastructure that adds no direct benefit, often added in anticipation of future change (live in the present!)
 * _Needless Repetition_: contains repetition of code, often with slight variations, that could be unified by an abstraction.
 * _Opacity_: intent is not apparent & the program is therefore difficult to understand/reason about.
 */

/*:
 ## The Copy Program: Let's Watch Code Rot!
 * Copy is a simple program.
 * It Takes input from the Keyboard module and outputs it to the Printer module.
 
 ![swift icon](copy.png)
 */


// COPY PROGRAM 1



class Keyboard {
  func readKeyboard()->Int {
    return Int(arc4random_uniform(10))
  }
}

class Printer {
  func prnt(_ num:Int) {
    print(#line, #function, num)
  }
}

class Copy1 {
  let kb = Keyboard()
  let prt = Printer()
  func copy() {
    var unicodeChar: Int = 0
    for _ in 0..<10 {
      unicodeChar = kb.readKeyboard()
      prt.prnt(unicodeChar)
    }
  }
}

let copy1 = Copy1()
copy1.copy()


/*:
 ## 1st Change
 * The client would like the Copy app to also be able read from a *tape reader*
 * You'd like to pass a Bool into the copy function. What's the problem with changing the signature of `Copy1's copy()`
 * Since you can't add a Bool to the signature of `copy` how can we add logic to handle sometimes using a *tape reader*?
 */

// COPY 2

class TapeReader {
  func readPaperTape()-> Int {
    return Int(arc4random_uniform(10))
  }
}


class Copy2 {
  var inputFlag = false
  let kb = Keyboard()
  let prt = Printer()
  let tapeRdr = TapeReader()
  
  func copy() {
    var unicodeChar: Int = 0
    for _ in 0..<10 {
      unicodeChar = !inputFlag ? kb.readKeyboard(): tapeRdr.readPaperTape()
      prt.prnt(unicodeChar)
    }
  }
}

let copy2 = Copy2()
copy2.inputFlag = true
copy2.copy()
copy2.inputFlag = false


/*:
 ## 2nd Change
 * The client would like to sometimes output to a *network printer*
 * The signature shouldn't change
 */

// COPY 3

class NetworkPrinter {
  func networkPrint(_ num:Int) {
    print(#line, #function, num)
  }
}

class Copy3 {
  var inputFlag:Bool = false
  var outputFlag:Bool = false
  let kb = Keyboard()
  let prt = Printer()
  let tapeRdr = TapeReader()
  let nw = NetworkPrinter()
  func copy() {
    var unicodeChar: Int = 0
    for _ in 0..<10 {
      unicodeChar = inputFlag == false ? kb.readKeyboard(): tapeRdr.readPaperTape()
      outputFlag == false ? prt.prnt(unicodeChar) : nw.networkPrint(unicodeChar)
    }
  }
}

/*:
 * So we can see where this is going!
 * Our original, simple program, has become twisted as we try to keep up with the changing requirements. Rot has set in.
 
 */

// COPY with interface



protocol Inputable {
  func read()-> Int
}

protocol Outputable {
  func write(_ num: Int)
}

class Printer2: Outputable {
  func write(_ num: Int) {
    print(#line, #function, "prints \(num)")
  }
}

class Keyboard2: Inputable {
  func read() -> Int {
    return Int(arc4random_uniform(10))
  }
}

class Copy4 {
  func copy(input:Inputable, output:Outputable) {
    var unicodeChar: Int = 0
    for _ in 0..<10 {
      unicodeChar = input.read()
      output.write(unicodeChar)
    }
  }
}

let copy4 = Copy4()
copy4.copy(input: Keyboard2(), output: Printer2())

class CrazyPrinterCopier:Inputable, Outputable {
  func read() -> Int {
    return Int(arc4random_uniform(10))
  }
  func write(_ num: Int) {
    print(#line, #function, "prints \(num)")
  }
}

let crazyPrinterCopier = CrazyPrinterCopier()
let copy5 = Copy4()
copy5.copy(input: crazyPrinterCopier, output: crazyPrinterCopier)


/*:
 * What specific design smells did the old Copy program exhibit?
 */
/*:
 * Copy is a higher level module than either the Printer or the Keyboard.
 * By this I mean that Copy is less concrete than either Printer or Keyboard. 
 * If we think about what it does generally then we can say that it takes an input (it doesn't really care about the source) from an input device and passes it to an output device (it doesn't care about the output device).
 * The Printer module and the Keyboard module are both more concrete. They output to paper, and input from a keyboard.
 * So, what we have is a dependency between a higher level module Copy (more abstract) and two lower level modules tangled up with specific details (more concrete).
 * The problem with Copy being dependent on the concrete details of Printer and Keyboard is that when these change then they break Copy. We are forced to update Copy to make a change.
 * What creating an interface does for us is wrap the concrete Printer and Keyboard in an abstract wrapper so that we can refer to them without needing to know about any concrete details, and hence we are no longer dependent on those details.
 * This is a good example of what is called _dependency inversion_.
 * We are also utilizing polymorphism.
 * Another way of describing what we've done to solve this problem is that we have encapsulated and separate into its own structure those dependencies that are likely to change.
 * The Copy program introduces a lot of powerful ideas that we will explore by considering each of the SOLID principles in turn.
 */




















