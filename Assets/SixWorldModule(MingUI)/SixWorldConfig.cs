using UnityEngine;
using System.Collections;
using System.Xml;
using System;

public class SixWorldConfig  {
    XmlDocument xmlFile ;
    private static SixWorldConfig instance;
    public static SixWorldConfig GetInstance() {
        if (instance == null){
            instance = new SixWorldConfig();
        }
        return instance;
    }
    private SixWorldConfig() {
        Debug.Log("Constructor Called");
    }
    void Start() {
        xmlFile = new XmlDocument();
        //string path = Application.dataPath + "/SixWorldModule(MingUI)/TestXML.xml";
        //xmlFile.Load(path);

        string data = Resources.Load("Data/TestXML").ToString();
        xmlFile.LoadXml(data);

        XmlNodeList nodeList = xmlFile.SelectSingleNode("Message").ChildNodes;
        var itr = nodeList.GetEnumerator();
        while (itr.MoveNext()) {
            var node = (XmlElement)itr.Current;
            Debug.Log(node.GetAttribute("id") + ":" + node.GetAttribute("name"));
            var innerItr = node.ChildNodes.GetEnumerator();
            while (innerItr.MoveNext()) {
                var innerNode = (XmlElement)innerItr.Current;
                Debug.Log(innerNode.GetAttribute("name") + ":" + innerNode.InnerText);
            }
        }
    }
}
