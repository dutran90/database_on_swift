# database_on_swift
Project to learn how to use many types database on swift! Let enjoy it.

Enumerate: Array, mutable array, [NSDictionary],...
  for (idx, dic) in enumerate(content){
            if dic["name"] as String == name{
                content.removeObject(dic)
            }
        }

3D Transition in tableview
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations:
            { cell.layer.transform = CATransform3DMakeScale(1,1,1) })
    }

Send data between 2 ViewController
      override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject!){
            
            let indexPath : NSIndexPath = self.tvMain.indexPathForSelectedRow()!
            //make sure that the segue is going to secondViewController
            let contact = segue.destinationViewController as ContactVC
            contact.keyType = self.arrayKeys[indexPath.row]
            
    }

Call segue and send data
      func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //edit
        
        self.performSegueWithIdentifier("segueAddNew", sender: 1)
        
    }
      override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAddNew" {
            if sender?.integerValue == 1{...
            

Delete action cell
  func tableView(tbvContact: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{...

SearchBar textDidChange
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            is_searching = false
            tbvContact.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            filteredName = []
            filteredPhone = []
            filteredMail = []
            for var index = 0; index < arrName.count; index++
            {
                var currentString = arrName[index] as String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    filteredName.append(arrName[index])
                    filteredPhone.append(arrPhone[index])
                    filteredMail.append(arrMail[index])
                }
            }
            tbvContact.reloadData()
        }
    }

Get and update file plist
  let path = NSBundle.mainBundle().pathForResource("contact", ofType: "plist")!
  var content = NSArray(contentsOfFile: path)
  ...modify content
  content.writeToFile(path, atomically: true)

Get and update NSUserDefault
    var udContact: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    udContact.setValue(arrDicContact, forKey: "arrDicContact")
    udContact.synchronize()
    

