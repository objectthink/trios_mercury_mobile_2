//
//  SignalViewController.swift
//  TRIOS_MOBILE
//
//  Created by stephen eshelman on 10/3/15.
//  Copyright © 2015 objectthink.com. All rights reserved.
//

import UIKit

class SignalViewController: UITableViewController, MercuryInstrumentDelegate
{
   var _signals:[Float]?
   
   var instrument: MercuryInstrument?
   {
      didSet
      {
         // Update the view.
         //self.configureView()
      }
   }
   
   func configureView()
   {
      instrument!.addDelegate(self)
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
      tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
      
      _signals = [Float]()
   }
   
   override func viewDidAppear(animated: Bool)
   {
      instrument!.addDelegate(self)
   }
   override func viewDidDisappear(animated: Bool)
   {
      instrument!.removeDelegate(self)
   }
   
   override func didReceiveMemoryWarning()
   {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      // #warning Incomplete implementation, return the number of sections
      return 1
   }
   
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      // #warning Incomplete implementation, return the number of rows
      return (_signals?.count)!
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath)
      
      let procedure = MercuryGetProcedureResponse()
      let s = procedure.signalToString(Int32(indexPath.row))
      
      let t = NSString(format: "%@ \t%.2f", s as String, self._signals![indexPath.row])
      
      // Configure the cell...
      cell.textLabel?.text = t as String
      //cell.textLabel?.text = "777"
      
      return cell
   }
   
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.performSegueWithIdentifier("showSignalChooser", sender: tableView)
   }
   
   func stat(message: NSData!, withSubcommand subcommand: uint)
   {
      print("stat in signal view")
      
      dispatch_async(dispatch_get_main_queue(),
      { () -> Void in
         if subcommand == 0x00020002
         {
            self._signals?.removeAll()
            
            let count = message.length/4
            
            for i in 0...count-1
            {
               let signal = self.instrument?.floatAtOffset(UInt(i*4), inData: message)
               
               self._signals?.append(signal!)
            }
         }
         
         self.tableView.reloadData()
      })
   }
   
   func response(message: NSData!, withSequenceNumber sequenceNumber: uint, subcommand: uint, status: uint)
   {
   }
   
   func ackWithSequenceNumber(sequencenumber: uint)
   {
   }
   
   func nakWithSequenceNumber(sequencenumber: uint, andError errorcode: uint)
   {
   }
   
   func connected()
   {
   }
   
   func accept(access: MercuryAccess)
   {
   }
   
   /*
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
   
   /*
   // Override to support editing the table view.
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   if editingStyle == .Delete {
   // Delete the row from the data source
   tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
   } else if editingStyle == .Insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
   
   /*
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
   
   }
   */
   
   /*
   // Override to support conditional rearranging of the table view.
   override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
   
   /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
   
}
