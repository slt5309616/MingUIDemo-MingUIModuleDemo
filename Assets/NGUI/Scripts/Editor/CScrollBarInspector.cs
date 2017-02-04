using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEditor;
using Assets.Scripts.Com.MingUI;
using UnityEngine;

namespace Assets.NGUI.Scripts.Editor{
    [CustomEditor(typeof (CScrollBar))] ///
    internal class CScrollBarInspector : UIWidgetInspector {
        protected override void DrawCustomProperties(){
            NGUIEditorTools.DrawProperty("Track", serializedObject, "Track");
            NGUIEditorTools.DrawProperty("Thumb", serializedObject, "Thumb");
            NGUIEditorTools.DrawProperty("UpBtn", serializedObject, "UpBtn");
            NGUIEditorTools.DrawProperty("DownBtn", serializedObject, "DownBtn");
            NGUIEditorTools.DrawProperty("Step", serializedObject, "step");
            base.DrawCustomProperties();
        }
    }
}