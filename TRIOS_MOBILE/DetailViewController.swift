//
//  DetailViewController.swift
//  TRIOS_MOBILE
//
//  Created by stephen eshelman on 10/2/15.
//  Copyright © 2015 objectthink.com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, MercuryInstrumentDelegate
{
   var _instrument: MercuryInstrument!

   var detailItem: String?
   {
      didSet
      {
          // Update the view.
          self.configureView()
      }
   }

   func configureView()
   {
      //title = self.detailItem
      
      _instrument = MercuryInstrument()
      
      _instrument.addDelegate(self)
      
      _instrument.connectToHost(self.detailItem, andPort: 8080)
      
      _instrument.loginWithUsername(
         "NEW_AND_IMPROVED_IPAD",
         machineName: "MAC",
         ipAddress: "10.10.0.0",
         access: 1000)
   }

   override func viewDidLoad()
   {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      self.configureView()
   }
   
   override func viewDidAppear(animated: Bool)
   {
      //title = "view did appear"
      
      _instrument.sendCommand(MercuryGetProcedureStatusCommand())
      {
         (response:MercuryResponse!) -> Void in
            
         print("got here")
            
         let r = MercuryProcedureStatusResponse(message: response.bytes)
         
         print(r.endStatus)
         print(r.runStatus)
         print(r.currentSegmentId)
            
         let runStatus = r.runStatus.rawValue
            
         print(runStatus)
         
         dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
               switch(runStatus)
               {
               case  0:
                  self.title = "Status: Idle"
               case 1:
                  self.title = "Status: PreTest"
               case 2:
                  self.title = "Status: Test"
               case 3:
                  self.title = "Status: PostTest"
               default:
                  self.title = ""
               }

            })
      }
   }

   override func viewDidDisappear(animated: Bool)
   {
      //_instrument.disconnect()
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if segue.identifier == "showSignals"
      {
         let controller = (segue.destinationViewController as! SignalViewController)
         
         controller.instrument = _instrument
      }
   }
   
   func connected()
   {
      print("connected")
   }
   
   func accept(access: MercuryAccess)
   {
      print("accept")
   }
   
   var _statCount:Int = 0
   func stat(message: NSData!, withSubcommand subcommand: uint)
   {
      _statCount++
      
      if _statCount >= 100
      {
         print("stat 100")
         _statCount = 0
      }
      
      //print(subcommand)
            
      if subcommand == ProcedureStatus.rawValue
      {
         let response = MercuryProcedureStatus(message: message)
         print(response.endStatus)
         print(response.runStatus)
         print(response.currentSegmentId)
         
         let runStatus = response.runStatus.rawValue
         dispatch_async(dispatch_get_main_queue(),
            { () -> Void in
               switch(runStatus)
               {
               case  0:
                  self.title = "Status: Idle"
               case 1:
                  self.title = "Status: PreTest"
               case 2:
                  self.title = "Status: Test"
               case 3:
                  self.title = "Status: PostTest"
               default:
                  self.title = ""
               }
               
         })
         
         print(self.title)
      }
   }
   
   func response(message: NSData!, withSequenceNumber sequenceNumber: uint, subcommand: uint, status: uint)
   {
      print("response")
      
      //if (subcommand == 9)
      //{
      //   let response = MercuryProcedureStatusResponse(message: message)
      //   print(response.endStatus)
      //   print(response.runStatus)
      //   print(response.currentSegmentId)
      //}
   }
   
   func ackWithSequenceNumber(sequencenumber: uint)
   {
      print("ack")
   }
   
   func nakWithSequenceNumber(sequencenumber: uint, andError errorcode: uint)
   {
      print("nak")
   }
}

