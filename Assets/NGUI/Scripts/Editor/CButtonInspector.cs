using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor{
    [CanEditMultipleObjects]
    [CustomEditor(typeof (CButton))] ///
     
    internal class CButtonInspector : UIButtonEditor{
        protected override void DrawProperties(){
            NGUIEditorTools.DrawProperty("Label", serializedObject, "Label");
            NGUIEditorTools.DrawProperty("relateChild", serializedObject, "relateChild");
            base.DrawProperties();
        }
    }
}