//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "VocalRecording1.sqlite"))
        }
        return sharedInstance
    }
    
    func createProjectNameTable() -> Bool {
        
        sharedInstance.database!.open()
        let iscreated = sharedInstance.database!.executeUpdate("CREATE TABLE ProjectNameList (ProjectIndex INTEGER PRIMARY KEY AUTOINCREMENT, ProjectName TEXT NOT NULL, ProjectNumber TEXT NOT NULL);", withArgumentsIn: nil)
        sharedInstance.database!.close()
        return iscreated
    }
    
    func createRecordingTable(tableName: String) -> Bool {
        sharedInstance.database!.open()
        let iscreated = sharedInstance.database!.executeUpdate("CREATE TABLE \(tableName) (RecordIndex INTEGER PRIMARY KEY AUTOINCREMENT, Record_Url TEXT NOT NULL, lyrics_txt TEXT NOT NULL, insertRecord2_Bool TEXT NOT NULL, insertLyrics_Boll TEXT NOT NULL, created_Date TEXT NOT NULL, created_time TEXT NOT NULL, recordName TEXT NOT NULL);", withArgumentsIn: nil)
        sharedInstance.database!.close()
        return iscreated
    }
    
    func addProjectNameData(projectList: ProjectList) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO ProjectNameList (ProjectName, ProjectNumber) VALUES (?,?)", withArgumentsIn: [projectList.ProjectName, projectList.ProjectNumber])
        sharedInstance.database!.close()
        return isInserted
    }

    
    func addRecordingData(recordInfo: RecordingInFo, tableName: String) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO \(tableName) (Record_Url, lyrics_txt, insertRecord2_Bool, insertLyrics_Boll, created_Date, created_time, recordName) VALUES (?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [recordInfo.Record_Url, recordInfo.lyrics_txt, recordInfo.insertRecord2_Bool, recordInfo.insertLyrics_Boll, recordInfo.created_Date, recordInfo.created_time, recordInfo.recordName])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateProjectNameData(projectList: ProjectList) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE ProjectNameList SET ProjectName=?, ProjectNumber=? WHERE ProjectIndex=?", withArgumentsIn: [projectList.ProjectName, projectList.ProjectNumber, projectList.ProjectIndex])
        sharedInstance.database!.close()
        return isUpdated
    }
   
    func updateRecordingData(recordInfo: RecordingInFo, tableName: String) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE \(tableName) SET Record_Url=?, lyrics_txt=?, insertRecord2_Bool=?, insertLyrics_Boll=?, created_Date=?, created_time=?, recordName=? WHERE RecordIndex=?", withArgumentsIn: [recordInfo.Record_Url , recordInfo.lyrics_txt, recordInfo.insertRecord2_Bool, recordInfo.insertLyrics_Boll, recordInfo.created_Date, recordInfo.created_time, recordInfo.recordName, recordInfo.RecordIndex])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteProjectNameData(projectList: ProjectList) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM ProjectNameList WHERE ProjectIndex=?", withArgumentsIn: [projectList.ProjectIndex])
        sharedInstance.database?.close()
        return isDeleted
    }
    
    func deleteRecordingData(recordInfo: RecordingInFo, tableName: String) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM \(tableName) WHERE RecordIndex=?", withArgumentsIn: [recordInfo.RecordIndex])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func deleteItemTable(tableName: String) -> Bool{
        sharedInstance.database!.open()
        let isdeletedItemTable = sharedInstance.database!.executeUpdate("DROP TABLE \(tableName)", withArgumentsIn: nil)
        return isdeletedItemTable
    }

    
    func getAllProjectNameData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM ProjectNameList", withArgumentsIn: nil)
        let marrStudentInfo: NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let projectName: ProjectList = ProjectList()
                projectName.ProjectIndex = resultSet.string(forColumn: "ProjectIndex")
                projectName.ProjectName = resultSet.string(forColumn: "ProjectName")
                projectName.ProjectNumber = resultSet.string(forColumn: "ProjectNumber")
                marrStudentInfo.add(projectName)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }

    func getAllRecordingData(tableName: String) -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM \(tableName)", withArgumentsIn: nil)
        let marrStudentInfo : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let recordInfo : RecordingInFo = RecordingInFo()
                recordInfo.RecordIndex = resultSet.string(forColumn: "RecordIndex")
                recordInfo.Record_Url = resultSet.string(forColumn: "Record_Url")
                recordInfo.lyrics_txt = resultSet.string(forColumn: "lyrics_txt")
                recordInfo.insertRecord2_Bool = resultSet.string(forColumn: "insertRecord2_Bool")
                recordInfo.insertLyrics_Boll = resultSet.string(forColumn: "insertLyrics_Boll")
                recordInfo.created_Date = resultSet.string(forColumn: "created_Date")
                recordInfo.created_time = resultSet.string(forColumn: "created_time")
                recordInfo.recordName = resultSet.string(forColumn: "recordName")
                marrStudentInfo.add(recordInfo)
            }
        }
        sharedInstance.database!.close()
        return marrStudentInfo
    }
}
