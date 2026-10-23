table 50170 "MID Machine"
{
    Caption = 'Machine';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Machine Code';
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Machine Name';
            DataClassification = CustomerContent;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(4; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
}
page 50171 "MID Machines"
{
    Caption = 'Machines';
    PageType = List;
    SourceTable = "MID Machine";
    ApplicationArea = Manufacturing;
    UsageCategory = Lists;

    CardPageId = "MID Machine Card"; // <-- This enables click-through to the card

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code") { ApplicationArea = All; }
                field("Name"; Rec."Name") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Description"; Rec."Description") { ApplicationArea = All; }
                field("Blocked"; Rec."Blocked") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewReleasedProdOrders)
            {
                ApplicationArea = Manufacturing;
                Caption = 'View Released Prod. Orders';
                RunObject = page "Released Production Orders";
                RunPageLink = "MID Machine Code" = FIELD(Code);
            }
        }
    }
}


page 50172 "MID Machine Card"
{
    Caption = 'Machine Card';
    PageType = Card;
    SourceTable = "MID Machine";
    ApplicationArea = Manufacturing;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec."Code") { ApplicationArea = All; }
                field("Name"; Rec."Name") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Description"; Rec."Description") { ApplicationArea = All; }
                field("Blocked"; Rec."Blocked") { ApplicationArea = All; }
            }
        }

        area(factboxes)
        {
            part(Attachments; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink =
                    "Table ID" = CONST(DATABASE::"MID Machine"),
                    "No." = FIELD(Code);
            }
            part(MachineLog; "MID Machine Log FactBox")
            {
                ApplicationArea = All;
                Caption = 'Machine Log';
                SubPageLink = "Machine Code" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(MachineLogEntries)
            {
                ApplicationArea = Manufacturing;
                Caption = 'Machine Log';
                Image = Log;
                ToolTip = 'Add or review maintenance, QA and safety entries for this machine.';
                RunObject = page "MID Machine Log Entries";
                RunPageLink = "Machine Code" = field(Code);
            }
        }
        area(Promoted)
        {
            actionref(MachineLogEntries_Promoted; MachineLogEntries) { }
        }
    }
}


tableextension 50173 "MID Prod. Order Machine" extends "Production Order"
{
    fields
    {
        field(50170; "MID Machine Code"; Code[20])
        {
            Caption = 'Machine';
            DataClassification = CustomerContent;
            TableRelation = "MID Machine".Code WHERE("Location Code" = FIELD("Location Code"));
            // The WHERE filter keeps choices to machines at the same Location as the Prod. Order.
        }
    }
}
pageextension 50174 "MID Rel. Prod. Orders Machine" extends "Released Production Orders"
{
    layout
    {
        addafter("Location Code")
        {
            field("MID Machine Code"; Rec."MID Machine Code")
            {
                ApplicationArea = Manufacturing;

                trigger OnDrillDown()
                var
                    mc: Record "MID Machine";
                begin
                    if mc.Get(Rec."MID Machine Code") then
                        PAGE.Run(PAGE::"MID Machine Card", mc);
                end;
            }
        }
    }
}

pageextension 50175 "MID Rel. Prod. Order Machine" extends "Released Production Order"
{
    layout
    {
        // Place near Location Code on the card
        addafter("Location Code")
        {
            field("MID Machine Code"; Rec."MID Machine Code")
            {
                ApplicationArea = Manufacturing;
                Editable = IsReleased;
                ToolTip = 'Select the machine to tie this released production order to.';
            }
        }
    }

    var
        IsReleased: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsReleased := (Rec.Status = Rec.Status::Released);
    end;
}
enum 50176 "MID Machine Log Type"
{
    Extensible = true;

    value(0; Maintenance) { Caption = 'Maintenance'; }
    value(1; QA) { Caption = 'QA'; }
    value(2; Safety) { Caption = 'Safety'; }
    value(99; Other) { Caption = 'Other'; }
}
table 50177 "MID Machine Log"
{
    Caption = 'Machine Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Machine Code"; Code[20])
        {
            Caption = 'Machine Code';
            TableRelation = "MID Machine".Code;
        }
        field(3; "Log Type"; Enum "MID Machine Log Type")
        {
            Caption = 'Type';
        }
        field(4; "Log Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Notes"; Text[250])
        {
            Caption = 'Notes';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(MachineDate; "Machine Code", "Log Date") { }
    }

    trigger OnInsert()
    begin
        if "Log Date" = 0D then
            "Log Date" := Today;
        if "User ID" = '' then
            "User ID" := UserId;
    end;
}
page 50178 "MID Machine Log FactBox"
{
    Caption = 'Machine Log';
    PageType = ListPart;
    SourceTable = "MID Machine Log";
    ApplicationArea = Manufacturing;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Log Date"; Rec."Log Date") { ApplicationArea = All; }
                field("Log Type"; Rec."Log Type") { ApplicationArea = All; }
                field("Notes"; Rec."Notes") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; Editable = false; }
            }
        }
    }
}
permissionsetextension 50179 "MID Machines - Bus. Premium" extends "D365 BUS PREMIUM"
{
    Permissions =
        tabledata "MID Machine" = RIMD,
        tabledata "MID Machine Log" = RIMD;
}

permissionset 50170 "MID MACHINES"
{
    Assignable = true;
    Caption = 'Production Machines';
    Permissions =
        tabledata "MID Machine" = RIMD,
        tabledata "MID Machine Log" = RIMD,
        table "MID Machine" = X,
        table "MID Machine Log" = X,
        page "MID Machines" = X,
        page "MID Machine Card" = X,
        page "MID Machine Log FactBox" = X,
        page "MID Machine Log Entries" = X;
}

page 50180 "MID Machine Log Entries"
{
    Caption = 'Machine Log';
    PageType = List;
    SourceTable = "MID Machine Log";
    SourceTableView = sorting("Machine Code", "Log Date") order(descending);
    ApplicationArea = Manufacturing;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Machine Code"; Rec."Machine Code") { ApplicationArea = All; }
                field("Log Date"; Rec."Log Date") { ApplicationArea = All; }
                field("Log Type"; Rec."Log Type") { ApplicationArea = All; }
                field("Notes"; Rec."Notes") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
            }
        }
    }
}
