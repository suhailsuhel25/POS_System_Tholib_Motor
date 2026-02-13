'use client';

import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { CheckCircle2 } from "lucide-react";

interface SuccessAlertProps {
    open: boolean;
    onClose: () => void;
    title?: string;
    message: string;
}

export function SuccessAlert({ open, onClose, title = "Berhasil", message }: SuccessAlertProps) {
    return (
        <AlertDialog open={open} onOpenChange={onClose}>
            <AlertDialogContent className="border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
                <AlertDialogHeader>
                    <div className="flex items-center gap-3">
                        <div className="w-12 h-12 rounded-full bg-[#E3FCEF] dark:bg-[#1C3329] flex items-center justify-center">
                            <CheckCircle2 className="w-6 h-6 text-[#006644] dark:text-[#22A06B]" />
                        </div>
                        <div className="flex-1">
                            <AlertDialogTitle className="text-lg font-bold text-[#172B4D] dark:text-white">
                                {title}
                            </AlertDialogTitle>
                        </div>
                    </div>
                    <AlertDialogDescription className="text-base text-[#626F86] dark:text-[#8C9BAB] mt-3 whitespace-pre-line">
                        {message}
                    </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogAction
                        onClick={onClose}
                        className="bg-[#0052CC] hover:bg-[#0747A6] text-white font-medium h-10"
                    >
                        Selesai
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    );
}
