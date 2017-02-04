using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof (CVBox))] ///
    
    internal class CVBoxInspector : UISpriteInspector{
        protected override void DrawCustomProperties(){
            NGUIEditorTools.DrawProperty("Content", serializedObject, "Content");
            NGUIEditorTools.DrawProperty("Bar", serializedObject, "Bar");
            NGUIEditorTools.DrawProperty("Mask", serializedObject, "Mask");
            base.DrawCustomProperties();
        }
    }
}