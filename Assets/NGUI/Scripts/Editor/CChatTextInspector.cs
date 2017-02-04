using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof(CChatText))]
    internal class CChatTextInspector : UISpriteInspector {
        protected override void DrawCustomProperties(){
            NGUIEditorTools.DrawProperty("Content", serializedObject, "Content");
            NGUIEditorTools.DrawProperty("CScrollBar", serializedObject, "Bar");
            NGUIEditorTools.DrawProperty("Label", serializedObject, "Label");
            NGUIEditorTools.DrawProperty("MaxLabel", serializedObject, "MaxLabel");
            
            base.DrawCustomProperties();
        }
    }
}